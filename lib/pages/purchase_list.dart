import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database.dart';
import '../models/user.dart';
import 'package:my_app/pages/setting_page.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class Transaction {
  final String date;
  final String description;
  final int amount;
  final int balance;
  final String imagePath; // 이미지 경로 추가
  final String? barcodePath;

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.balance,
    required this.imagePath, // 이미지 경로
    this.barcodePath,
  });
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  // 🔧 수정: 구매 옵션 대신 정렬 옵션으로 변경
  String selectedSortOption = '최신순'; // 기본값 최신순
  final List<String> sortOptions = ['최신순', '오래된 순', '가나다 순'];
  
  Widget _buildStarPoint() {
    if (_currentUserKey == null) {
      return const Text(
        '-',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF383C59),
        ),
      );
    }
    return ValueListenableBuilder<Box<User>>(
      valueListenable: DatabaseService.users.listenable(keys: [_currentUserKey!]),
      builder: (_, box, __) {
        final user = box.get(_currentUserKey!);
        final point = user?.starPoint ?? 0;
        return Text(
          '$point',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF383C59),
          ),
        );
      },
    );
  }
  void _showTransactionDetailDialog(Transaction tx) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('거래 상세 정보'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            
            children: [
              // 이미지 표시
              Align(
              alignment: Alignment.center, // 이미지 중앙 정렬
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  tx.imagePath,
                  width: 200,
                  height: 200,// 이미지가 잘리거나 늘어나지 않도록 설정
                ),
              ),
            ),
            const SizedBox(height: 1),
            if (tx.barcodePath != null) // 바코드 경로가 있는 경우에만 표시
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  tx.barcodePath!,
                  width: 250, // 바코드 특성상 가로가 길게
                  height: 80,  // 세로는 상대적으로 짧게
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Text('날짜: ${tx.date}',style: const TextStyle(fontSize: 16)),
              Text('설명: ${tx.description}',style: const TextStyle(fontSize: 16)),
              Text('금액: ${formatAmount(tx.amount)}',style: const TextStyle(fontSize: 16)),
              Text('잔액: ${formatAmount(tx.balance)}',style: const TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  // 거래내역만 사용
  final List<Transaction> transactions = [
    // 기존 7개
    Transaction(
      date: '2025-11-06',
      description: '메가커피 아메리카노[구매]',
      amount: -2500,
      balance: 87500,
      imagePath: 'assets/images/americano.png',
      barcodePath: 'assets/images/barcode.png', 
    ),
    Transaction(
      date: '2025-11-05',
      description: '스타벅스 5천원권 김지안님께[선물]',
      amount: -5000,
      balance: 90000,
      imagePath: 'assets/images/sb5000.png', // 확장자 수정
      barcodePath: 'assets/images/barcode.png', 
    ),
    Transaction(
      date: '2025-11-03',
      description: '890포인트 전환[적립]',
      amount: 890,
      balance: 95022,
      imagePath: 'assets/images/cafe.png',
      
    ),
    Transaction(
      date: '2025-10-31',
      description: '1만 포인트[충전]',
      amount: 10000,
      balance: 102132,
      imagePath: 'assets/images/coffee.png',
      
    ),
    Transaction(
      date: '2025-10-30',
      description: 'CU 편의점 3천원권[구매]',
      amount: -3000,
      balance: 99232,
      imagePath: 'assets/images/coffee.png',
    ),
    Transaction(
      date: '2025-10-29',
      description: '커피빈 아메리카노[구매]',
      amount: -4500,
      balance: 94732,
      imagePath: 'assets/images/coffee.png',
    ),
    Transaction(
      date: '2025-10-23',
      description: '배달의 민족 만 이천원권[구매]',
      amount: -12000,
      balance: 106432,
      imagePath: 'assets/images/coffee.png',
    ),
  ];

String formatAmount(int amount) {
  final formattedAmount = amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match.group(1)},'); // 매치된 그룹 뒤에 쉼표만 추가
      
  return '$formattedAmount P'; // P는 이제 띄어쓰기를 포함하여 한 번만 붙입니다.
}


  int? _currentUserKey;

  @override
  void initState() {
    super.initState();
    _currentUserKey = DatabaseService.currentUserKey();
  }

  List<Transaction> _getSortedTransactions() {
    final sorted = [...transactions];
    switch (selectedSortOption) {
      case '오래된 순':
        sorted.sort((a, b) => a.date.compareTo(b.date));
        break;
      case '가나다 순':
        sorted.sort((a, b) => a.description.compareTo(b.description));
        break;
      case '최신순':
      default:
        sorted.sort((a, b) => b.date.compareTo(a.date));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = _getSortedTransactions();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Image.asset('assets/images/logo.png', width: 40, height: 40),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'CASHLOOP',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/people'),
                  child:
                      Image.asset('assets/images/people.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/search'),
                  child:
                      Image.asset('assets/images/home.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                  child:
                      Image.asset('assets/images/more.png', width: 24, height: 24),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 프로필 + 포인트
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<Box<User>>(
                  valueListenable:
                      DatabaseService.users.listenable(keys: [_currentUserKey!]),
                  builder: (context, box, _) {
                    final user = box.get(_currentUserKey!);
                    final userName = user?.username ?? '사용자';
                    final profileImage = 'assets/images/hello.png';
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            profileImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$userName님',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                              '반가워요 $userName님, 구매 내역을 확인하세요!',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/point.png',
                      width: 20,
                      height: 20,
                      color: const Color(0xFF383C59),
                    ),
                    const SizedBox(width: 6),
                    _buildStarPoint(),
                  ],
                ),
              ],
            ),
          ),

          // 하단 탭 (디자인 그대로 유지)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['선물하기', '구매내역', '내 기프티콘'].map((tab) {
                final bool isSelected = tab == '구매내역';
                return GestureDetector(
                  onTap: () {
                    if (tab == '선물하기') {
                      Navigator.pushNamed(context, '/search');
                    } else if (tab == '내 기프티콘') {
                      Navigator.pushNamed(context, '/my_coupons');
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        tab,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFF878C93),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '────────',
                        style: TextStyle(
                            color:
                                isSelected ? Colors.black : Colors.transparent),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // 🔧 정렬 바로 교체
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: DropdownButton<String>(
                  value: selectedSortOption,
                  icon:
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    setState(() {
                      selectedSortOption = value!;
                    });
                  },
                  items: sortOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return sortOptions.map((String option) {
                      return Center(
                        child: Text(
                          option,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
          // 총 개수
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '총 ${transactions.length}건',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // 거래 내역 리스트
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: sortedTransactions.map((tx) {
                final isPositive = tx.amount > 0;
                return GestureDetector(
                  onTap: () {
                    _showTransactionDetailDialog(tx);  // 다이얼로그 띄우기
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        isPositive
                            ? Icons.add_circle_outline
                            : Icons.remove_circle_outline,
                        color: isPositive ? Colors.green : Colors.redAccent,
                      ),
                      title: Text(tx.description,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(tx.date,
                          style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${isPositive && tx.amount != 0 ? '+' : ''}${formatAmount(tx.amount)}',
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text('잔액: ${formatAmount(tx.balance.abs())}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
