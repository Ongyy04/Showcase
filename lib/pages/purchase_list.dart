import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database.dart';
import '../models/user.dart';

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
  final int pointAmount;
  final String imagePath;
  final String? barcodePath;

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.balance,
    required this.pointAmount,
    required this.imagePath,
    this.barcodePath,
  });
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String selectedSortOption = '나에게 선물';
  final List<String> sortOptions = ['나에게 선물', '친구에게 선물', '적립'];

  int? _currentUserKey;

  @override
  void initState() {
    super.initState();
    _currentUserKey = DatabaseService.currentUserKey();
  }

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
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tx.imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: Image.asset(
                        tx.imagePath,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: tx.pointAmount >= 0
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tx.pointAmount >= 0 ? '적립' : '사용',
                        style: TextStyle(
                          color: tx.pointAmount >= 0 ? Colors.green[800] : Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${tx.pointAmount >= 0 ? '+' : '-'}${formatAmount(tx.amount.abs())}',
                      style: TextStyle(
                        color: tx.pointAmount >= 0 ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tx.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(height: 24, thickness: 1.2),
                Column(
                  children: [
                    _detailRow(Icons.calendar_today_outlined, '날짜', tx.date),
                    const SizedBox(height: 8),
                    _detailRow(Icons.payment, '결제 수단', '신용카드'),
                    const SizedBox(height: 8),
                    _detailRow(Icons.category_outlined, '카테고리', '카페'),
                    const SizedBox(height: 8),
                    _detailRow(Icons.attach_money, '결제 금액',
                        '${tx.pointAmount >= 0 ? '+' : '-'}${formatAmount(tx.pointAmount.abs())}'),
                    const SizedBox(height: 8),
                    _detailRow(Icons.account_balance_wallet_outlined, '잔액',
                        formatAmount(tx.balance)),
                    if (tx.barcodePath != null) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Image.asset(
                          tx.barcodePath!,
                          width: 250,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF383C59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ],
    );
  }
final List<Transaction> transactions = [
  Transaction(
    date: '2025-11-06',
    description: '메가커피 아메리카노[구매]',
    amount: 2500,
    pointAmount: -1144,
    balance: 0, // 이전 balance 1028에서 pointAmount 반영
    imagePath: 'assets/images/americano.png',
    barcodePath: 'assets/images/barcode.png',
  ),
  Transaction(
    date: '2025-11-05',
    description: '스타벅스 5천원권 김지안님께[선물]',
    amount: 5000,
    pointAmount: -151,
    balance: 0, 
    imagePath: 'assets/images/sb5000.png',
    barcodePath: 'assets/images/barcode.png',
  ),
  Transaction(
    date: '2025-11-04',
    description: '메가커피 아메리카노 2잔 김민수님께[선물]',
    amount: 5000,
    pointAmount:- 3000,
    balance: 151, // 직전 거래 기준으로 누적 balance 계산
    imagePath: 'assets/images/americano.png',
    barcodePath: 'assets/images/barcode.png',
  ),
  Transaction(
    date: '2025-11-03',
    description: '스타벅스 1만원권 박지영님께[선물]',
    amount: 10000,
    pointAmount: 0,
    balance: 3151,
    imagePath: 'assets/images/sb10000.png',
    barcodePath: 'assets/images/barcode.png',
  ),
  Transaction(
    date: '2025-10-30',
    description: 'CU 편의점 5천원권 이승현님께[선물]',
    amount: 5000,
    pointAmount: -5000,
    balance: 3151,
    imagePath: 'assets/images/cu5000.png',
    barcodePath: 'assets/images/barcode.png',
  ),
  Transaction(
    date: '2025-11-03',
    description: '890포인트 전환[적립]',
    amount: 0,
    pointAmount: 890,
    balance: 8151, // 이전 잔액 + pointAmount
    imagePath: 'assets/images/cafe.png',
    barcodePath: 'assets/images/barcode.png',
  ),
  Transaction(
    date: '2025-10-31',
    description: '5천 포인트[적립]',
    amount: 0,
    pointAmount: 5000,
    balance: 7261,
    imagePath: 'assets/images/coffee.png',
  ),
  Transaction(
    date: '2025-10-30',
    description: 'CU 편의점 3천원권[구매]',
    amount: 3000,
    pointAmount: 0,
    balance: 2261,
    imagePath: 'assets/images/coffee.png',
  ),
  Transaction(
    date: '2025-10-29',
    description: '커피빈 아메리카노[구매]',
    amount: 4500,
    pointAmount:- 2200,
    balance: 4461,
    imagePath: 'assets/images/coffee.png',
  ),
  Transaction(
    date: '2025-10-23',
    description: '배달의 민족 만 이천원권[구매]',
    amount: 12000,
    pointAmount:- 3000,
    balance: 7461,
    imagePath: 'assets/images/coffee.png',
  ),
];


  String formatAmount(int amount) {
    final formattedAmount = amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match.group(1)},');
    return '$formattedAmount P';
  }

  List<Transaction> _getSortedTransactions() {
    final List<Transaction> combined = [...transactions];

    if (_currentUserKey != null) {
      final box = DatabaseService.users;
      final user = box.get(_currentUserKey!);
      if (user != null) {
        final newTxs = user.transactionHistory.map((tx) => Transaction(
              date: tx['date'] ?? '',
              description: tx['description'] ?? '',
              amount: tx['amount'] ?? 0,
              balance: tx['balance'] ?? 0,
              pointAmount: tx['pointAmount'] ?? 0,
              imagePath: tx['imagePath'] ?? 'assets/images/coffee.png',
              barcodePath: tx['barcodePath'],
            )).toList();
        combined.insertAll(0, newTxs);
      }
    }

    switch (selectedSortOption) {
      case '친구에게 선물':
        combined.retainWhere((tx) => tx.description.contains('님께[선물]'));
        break;
      case '적립':
        combined.retainWhere((tx) => tx.description.contains('[적립]'));
        break;
      case '나에게 선물':
      default:
        combined.retainWhere((tx) => tx.description.contains('[구매]') || tx.description.contains('나에게 선물'));
    }

    combined.sort((a, b) => b.date.compareTo(a.date));
    return combined;
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
                  child: Image.asset('assets/images/people.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/search'),
                  child: Image.asset('assets/images/home.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                  child: Image.asset('assets/images/more.png', width: 24, height: 24),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 + 포인트
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentUserKey != null)
                  ValueListenableBuilder<Box<User>>(
                    valueListenable: DatabaseService.users.listenable(keys: [_currentUserKey!]),
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
                                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              Text(
                                '반가워요 $userName님, 구매 내역을 확인하세요!',
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
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
          // 하단 탭
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
                          color: isSelected ? Colors.black : const Color(0xFF878C93),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '────────',
                        style: TextStyle(color: isSelected ? Colors.black : Colors.transparent),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // 정렬
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: DropdownButton<String>(
                  value: selectedSortOption,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSortOption = value;
                      });
                    }
                  },
                  items: sortOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return sortOptions.map((String option) {
                      return Center(
                        child: Text(option,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '총 ${sortedTransactions.length}건',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: sortedTransactions.map((tx) {
                final isPositive = tx.pointAmount > 0;
                return GestureDetector(
                  onTap: () => _showTransactionDetailDialog(tx),
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
                        isPositive ? Icons.add_circle_outline : Icons.remove_circle_outline,
                        color: isPositive ? Colors.green : Colors.redAccent,
                      ),
                      title: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Row(
                        children: [
                          Text(
                            '${tx.amount.abs().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            tx.date,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${tx.pointAmount > 0 ? '+' : ''}${formatAmount(tx.pointAmount)}',
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
