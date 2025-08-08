// lib/services/directory_service.dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart'; // debugPrint
import 'package:excel/excel.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 엑셀/CSV에서 읽어온 1명 레코드
class DirectoryRecord {
  final String birthday; // 예: "2005.07.13"
  /// 'g' | 'b'
  final String gender;
  const DirectoryRecord({required this.birthday, required this.gender});
}

class DirectoryService {
  /// 전화번호(숫자만) -> 레코드
  static final Map<String, DirectoryRecord> _dir = {};
  static bool _loaded = false;

  /// 가입자 추가분을 저장하는 override 박스(자산보다 우선 적용)
  static Box? _overrideBox;

  /// 앱 시작 시 호출
  static Future<void> init() async {
    // 0) override 박스 오픈 (항상 먼저)
    if (!Hive.isBoxOpen('directory_override')) {
      _overrideBox = await Hive.openBox('directory_override');
    } else {
      _overrideBox = Hive.box('directory_override');
    }

    // 1) CSV 우선 로드 (웹에서 XLSX가 자주 깨짐)
    final csvPath = 'assets/data/user_data.csv';
    bool loadedFromCsv = false;
    try {
      final csvBytes = await rootBundle.load(csvPath);
      debugPrint('[DirectoryService] CSV found. bytes=${csvBytes.lengthInBytes}');
      await _loadFromCsvBytes(csvBytes.buffer.asUint8List());
      _loaded = true;
      loadedFromCsv = true;
    } catch (e) {
      debugPrint('[DirectoryService] CSV not available or failed. $e');
    }

    // 2) CSV 실패 시 XLSX 시도 (자산 등록되어 있으면)
    if (!loadedFromCsv) {
      await _loadFromAssetWithLogs('assets/data/user_data.xlsx'); // pubspec.yaml에 등록 필수
    }

    // 3) override 병합 (회원가입으로 추가/수정된 항목 덮어쓰기)
    await _mergeOverride();

    debugStatus();
  }

  /// 전화번호로 조회 (하이픈/공백/문자 상관없이 숫자만 비교)
  static DirectoryRecord? recordForPhone(String phone) {
    final key = _digitsOnly(phone);
    final hit = _dir[key];
    debugPrint('[DirectoryService] lookup "$phone" -> key="$key" => ${hit == null ? "MISS" : "HIT"}');
    if (hit == null) {
      // 끝 8자리로 후보 보여주기 (포맷 불일치 진단에 도움)
      final tail = key.length >= 8 ? key.substring(key.length - 8) : key;
      final candidates = _dir.keys.where((k) => k.endsWith(tail)).take(5).toList();
      debugPrint('  tail("$tail") candidates: $candidates');
    }
    return hit;
  }

  /// 외부에서 통으로 교체 (CSV/하드코딩 등)
  static void replaceDirectory(Map<String, DirectoryRecord> phoneToRecord) {
    _dir
      ..clear()
      ..addAll(
        phoneToRecord.map(
          (k, v) => MapEntry(_digitsOnly(k), _normalizeRecord(v)),
        ),
      );
    _loaded = true;
    debugStatus();
  }

  /// 개발용: 에셋에서 강제 리로드(XLSX → 실패 시 CSV 순서 아님)
  static Future<void> forceReloadFromAsset() async {
    await _loadFromAssetWithLogs('assets/data/user_data.xlsx');
    await _mergeOverride();
    debugStatus();
  }

  /// 회원가입 등으로 한 건 추가/수정 (assets를 직접 못 고치니 override에 저장)
  static Future<void> addOrUpdateRecord({
    required String phone,
    required String birthday,
    required String gender,
  }) async {
    final key = _digitsOnly(phone);
    final rec = _normalizeRecord(DirectoryRecord(birthday: birthday, gender: gender));

    // 메모리 반영
    _dir[key] = rec;

    // 영구 저장 (다음 실행 시에도 mergeOverride로 적용)
    await _overrideBox?.put(key, {'birthday': rec.birthday, 'gender': rec.gender});

    debugPrint('[DirectoryService] upsert override: $key => (${rec.birthday}, ${rec.gender})');
    debugStatus();
  }

  /// 현재 상태 요약 로그
  static void debugStatus() {
    debugPrint('[DirectoryService] loaded=$_loaded, count=${_dir.length}');
    var i = 0;
    for (final e in _dir.entries) {
      debugPrint('  sample[$i]: ${e.key} => (${e.value.birthday}, ${e.value.gender})');
      if (++i >= 3) break;
    }
  }

  // ------------------------------------------------------------------
  // 내부 구현
  // ------------------------------------------------------------------

  /// 에셋(xlsx) 읽기 + 로그 + CSV 폴백
  static Future<void> _loadFromAssetWithLogs(String assetPath) async {
    debugPrint('=== DirectoryService.loadFromAssetExcel("$assetPath") ===');
    ByteData data;
    try {
      data = await rootBundle.load(assetPath);
    } catch (e, st) {
      debugPrint('!! rootBundle.load FAILED: $e\n$st');
      _loaded = false;
      return;
    }

    final bytes = data.buffer.asUint8List();
    debugPrint('asset bytes length=${bytes.length}');

    // xlsx는 ZIP 시그니처: "PK" (0x50, 0x4B)
    final isZip = bytes.length >= 2 && bytes[0] == 0x50 && bytes[1] == 0x4B;
    debugPrint('isZip(xlsx)=$isZip');

    // 1) XLSX 시도
    try {
      await _loadFromExcelBytes(bytes);
      debugPrint('>> XLSX parsed successfully.');
      _loaded = true;
      return;
    } catch (e, st) {
      debugPrint('!! XLSX parse FAILED: $e\n$st');
    }

    // 2) CSV 폴백 (같은 경로에 user_data.csv가 있을 때)
    try {
      final csvPath = assetPath.replaceAll('.xlsx', '.csv');
      final csvBytes = await rootBundle.load(csvPath);
      debugPrint('Trying CSV fallback: $csvPath, bytes=${csvBytes.lengthInBytes}');
      await _loadFromCsvBytes(csvBytes.buffer.asUint8List());
      debugPrint('>> CSV parsed successfully.');
      _loaded = true;
      return;
    } catch (e, st) {
      debugPrint('!! CSV fallback FAILED: $e\n$st');
      _loaded = false;
    }
  }

  /// XLSX 바이트 파싱
  static Future<void> _loadFromExcelBytes(Uint8List bytes) async {
    debugPrint('[_loadFromExcelBytes] start, len=${bytes.length}');
    Excel excel;
    try {
      excel = Excel.decodeBytes(bytes);
    } catch (e, st) {
      debugPrint('[_loadFromExcelBytes] Excel.decodeBytes ERROR: $e\n$st');
      rethrow;
    }

    if (excel.tables.isEmpty) {
      debugPrint('[_loadFromExcelBytes] excel.tables is EMPTY');
      _dir.clear(); _loaded = true; return;
    }

    final table = excel.tables.values.first;
    if (table.rows.isEmpty) {
      debugPrint('[_loadFromExcelBytes] table.rows is EMPTY');
      _dir.clear(); _loaded = true; return;
    }

    // 헤더 인식 (한/영 모두)
    final header = table.rows.first
        .map((c) => (c?.value?.toString() ?? '').trim().toLowerCase())
        .toList();
    debugPrint('header=$header (len=${header.length})');

    final phoneKeys    = const ['phone','전화번호','휴대폰','휴대전화','연락처','폰'];
    final birthdayKeys = const ['birthday','생일','birth','dob'];
    final genderKeys   = const ['gender','성별','sex'];

    int idxPhone    = _indexOfAny(header, phoneKeys);
    int idxBirthday = _indexOfAny(header, birthdayKeys);
    int idxGender   = _indexOfAny(header, genderKeys);

    // 네 파일이 [아이디, 생일, 전화번호, 성별] 구조였던 점 고려: 인덱스 방탄
    if (idxPhone < 0 && idxBirthday < 0 && idxGender < 0 && table.rows.first.length >= 4) {
      idxBirthday = 1; // 생일
      idxPhone    = 2; // 전화번호
      idxGender   = 3; // 성별
      debugPrint('fallback indices used => phone:$idxPhone birthday:$idxBirthday gender:$idxGender');
    } else {
      debugPrint('detected indices => phone:$idxPhone birthday:$idxBirthday gender:$idxGender');
    }

    final tmp = <String, DirectoryRecord>{};

    for (var r = 1; r < table.rows.length; r++) {
      final row = table.rows[r];

      String cell(int i) {
        if (i < 0 || i >= row.length) return '';
        final v = row[i]?.value;
        return (v == null) ? '' : v.toString().trim();
      }

      // 전화번호는 강력 보정
      final phone = _normalizePhone(cell(idxPhone));
      if (phone.isEmpty) continue;

      final rec = _normalizeRecord(DirectoryRecord(
        birthday: cell(idxBirthday),
        gender: cell(idxGender),
      ));
      tmp[phone] = rec;
    }

    replaceDirectory(tmp);
    debugPrint('[_loadFromExcelBytes] done. count=${_dir.length}');
  }

  /// CSV 바이트 파싱 (헤더: phone/전화번호, birthday/생일, gender/성별)
  static Future<void> _loadFromCsvBytes(Uint8List bytes) async {
    debugPrint('[_loadFromCsvBytes] start, len=${bytes.length}');
    final text = utf8.decode(bytes);
    final lines = const LineSplitter().convert(text);

    if (lines.isEmpty) {
      debugPrint('CSV empty'); _dir.clear(); _loaded = true; return;
    }

    final header = lines.first.split(',').map((e) => e.trim().toLowerCase()).toList();
    debugPrint('csv header=$header');

    final phoneKeys    = const ['phone','전화번호','휴대폰','휴대전화','연락처','폰'];
    final birthdayKeys = const ['birthday','생일','birth','dob'];
    final genderKeys   = const ['gender','성별','sex'];

    int idxPhone    = _indexOfAny(header, phoneKeys);
    int idxBirthday = _indexOfAny(header, birthdayKeys);
    int idxGender   = _indexOfAny(header, genderKeys);

    final tmp = <String, DirectoryRecord>{};

    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final cols = line.split(',').map((e) => e.trim()).toList();

      String at(int idx) => (idx >= 0 && idx < cols.length) ? cols[idx] : '';

      final phone = _normalizePhone(at(idxPhone));
      if (phone.isEmpty) continue;

      final rec = _normalizeRecord(DirectoryRecord(
        birthday: at(idxBirthday),
        gender: at(idxGender),
      ));
      tmp[phone] = rec;
    }

    replaceDirectory(tmp);
    debugPrint('[_loadFromCsvBytes] done. count=${_dir.length}');
  }

  /// override 박스 병합(자산보다 우선)
  static Future<void> _mergeOverride() async {
    final box = _overrideBox;
    if (box == null) return;

    for (final k in box.keys) {
      final v = box.get(k);
      if (v is Map && v.containsKey('birthday') && v.containsKey('gender')) {
        final rec = _normalizeRecord(DirectoryRecord(
          birthday: (v['birthday'] ?? '').toString(),
          gender: (v['gender'] ?? '').toString(),
        ));
        _dir[k.toString()] = rec; // 덮어쓰기
      }
    }
    debugPrint('[DirectoryService] override merged: ${box.length} entries');
  }

  // ---------- helpers ----------

  static int _indexOfAny(List<String> header, List<String> keys) {
    for (int i = 0; i < header.length; i++) {
      if (keys.contains(header[i])) return i;
    }
    return -1;
  }

  static DirectoryRecord _normalizeRecord(DirectoryRecord r) {
    final g = r.gender.trim().toLowerCase();
    final gender = (g == 'b' || g == 'male' || g == 'm' || g == '남' || g == '남성')
        ? 'b'
        : (g == 'g' || g == 'female' || g == 'f' || g == '여' || g == '여성')
            ? 'g'
            : 'g'; // 알 수 없으면 g
    return DirectoryRecord(birthday: r.birthday.trim(), gender: gender);
  }

  /// 전화번호 문자열을 강력 보정
  static String _normalizePhone(String raw) {
    var s = raw.trim();

    // 과학표기/소수점 숫자 문자열도 정수로
    if (RegExp(r'^[0-9]+(\.[0-9]+)?e[+|-]?[0-9]+$', caseSensitive: false).hasMatch(s) ||
        RegExp(r'^[0-9]+\.[0-9]+$').hasMatch(s)) {
      try { s = double.parse(s).toStringAsFixed(0); } catch (_) {}
    }

    // 최종 숫자만 추출
    s = _digitsOnly(s);

    // 한국 모바일 보정: 10자리 & '10' 시작 → 앞에 '0' 붙여 11자리(010…)
    if (s.length == 10 && s.startsWith('10')) s = '0$s';

    return s;
  }

  static String _digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');
}
