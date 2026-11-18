import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/models/transaction_model.dart';
import 'package:pocket_flow/services/transaction_service.dart';

class MonthlyTransactionDetailPage extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isIncome;
  const MonthlyTransactionDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.categoryIcon,
    required this.categoryColor,
    required this.isIncome,
  });

  @override
  State<MonthlyTransactionDetailPage> createState() =>
      _MonthlyTransactionDetailPageState();
}

class _MonthlyTransactionDetailPageState extends State<MonthlyTransactionDetailPage> {
  // Usefull Variable
  // selectedMonth
  // transactionDatails

  int totalDays = 0;
  int totalTransactions = 0;
  double totalAmount = 0.0;
  double transactionAverage = 0.0;
  double dayAverage = 0.0;

  late DateTime selectedMonth;
  late Future<List<Map<String, dynamic>>> stream;

  List<Map<String, dynamic>> dasboardData = [];
  List<Map<String, dynamic>> transactionDatails = [];

  Future<void> _showMonthPicker(BuildContext context) async {
    DateTime pickedMonth = selectedMonth;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.monthYear,
            initialDateTime: DateTime(selectedMonth.year, selectedMonth.month),
            minimumDate: DateTime(DateTime.now().year - 1, DateTime.now().month),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              pickedMonth = DateTime(newDate.year, newDate.month);
            },
          ),
        );
      },
    );

    if (!mounted) return;
    if (pickedMonth.year == selectedMonth.year &&
        pickedMonth.month == selectedMonth.month) {
      return;
    }

    setState(() {
      selectedMonth = pickedMonth;
      stream = calculateData();
    });
  }

  String? _monthSelector(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return null;
    }
  }

  Future<List<Map<String, dynamic>>> calculateData() async {
    dasboardData.clear();
    transactionDatails.clear();
    totalDays = 0;
    totalTransactions = 0;
    totalAmount = 0.0;
    transactionAverage = 0.0;
    dayAverage = 0.0;

    final List<TransactionModel> monthlyTrxModels =
        await TransactionService.getFilteredTransactions(
          DateTime(selectedMonth.year, selectedMonth.month, 1, 0, 0, 0),
          DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59),
          [widget.categoryId],
          null,
        )!.first;

    List<Map<String, dynamic>> trxList = [];

    for (var element in monthlyTrxModels) {
      final DateTime dateTime = element.dateTime;
      final String date = DateFormat('yyyy-MM-dd').format(dateTime);
      final String time = DateFormat('hh:mm a').format(dateTime);

      if (transactionDatails.isEmpty || (transactionDatails.last['date'] != date)) {
        trxList = [];
        transactionDatails.add({'date': date, 'transactions': trxList});
      }

      if (transactionDatails.last['date'] == date) {
        trxList.add({
          'categoryName': widget.categoryName,
          'categoryIcon': widget.categoryIcon,
          'categoryColor': widget.categoryColor,
          'isIncome': widget.isIncome,
          'time': time,
          'title': element.title,
          'amount': element.transactionAmount,
        });
        totalAmount += element.transactionAmount;
      }
      transactionDatails.last['transactions'] = trxList;
    }

    totalDays = transactionDatails.length;
    totalTransactions = monthlyTrxModels.length;
    dayAverage = (totalDays == 0) ? 0 : totalAmount / totalDays;
    transactionAverage = (totalTransactions == 0) ? 0 : totalAmount / totalTransactions;

    dasboardData = [
      {
        'icon': Icons.account_balance_wallet,
        'color': (widget.isIncome) ? AppColors.income : AppColors.expense,
        'title': (widget.isIncome) ? 'Total Earned' : 'Total Spent',
        'amount': 'LKR ${totalAmount.toStringAsFixed(2)}',
      },
      {
        'icon': Icons.format_list_bulleted,
        'color': Colors.blue,
        'title': 'Total Transactions',
        'amount': totalTransactions.toStringAsFixed(0),
      },
      {
        'icon': Icons.bar_chart,
        'color': Colors.green,
        'title': 'Average per TRX',
        'amount': 'LKR ${transactionAverage.toStringAsFixed(2)}',
      },
      {
        'icon': Icons.calendar_month,
        'color': Colors.purple,
        'title': 'Average per Day',
        'amount': 'LKR ${dayAverage.toStringAsFixed(2)}',
      },
    ];

    return transactionDatails;
  }

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    stream = calculateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monthly Overview')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(CustomSize.defaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                color: AppColors.surface,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: CustomSize.defaultPadding),
                    child: Icon(
                      widget.categoryIcon,
                      color: widget.categoryColor,
                      size: 54,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.categoryName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Monthly transaction details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (DateTime(
                      selectedMonth.year,
                      selectedMonth.month,
                    ).isAfter(DateTime(DateTime.now().year - 1, DateTime.now().month))) {
                      setState(() {
                        selectedMonth = DateTime(
                          selectedMonth.year,
                          selectedMonth.month - 1,
                        );
                      });
                      stream = calculateData();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: AppColors.border, width: 1),
                      color: AppColors.surfaceVariant,
                    ),
                    child: Icon(Icons.keyboard_arrow_left, size: 32),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CustomSize.defaultPadding,
                      vertical: CustomSize.defaultPadding * 2,
                    ),
                    child: InkWell(
                      onTap: () {
                        _showMonthPicker(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border, width: 1),
                          color: AppColors.surfaceVariant,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.calendar_month, size: 32),
                            ),
                            Text(
                              '${_monthSelector(selectedMonth.month)} ${selectedMonth.year}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (DateTime(
                      selectedMonth.year,
                      selectedMonth.month,
                    ).isBefore(DateTime(DateTime.now().year, DateTime.now().month))) {
                      setState(() {
                        selectedMonth = DateTime(
                          selectedMonth.year,
                          selectedMonth.month + 1,
                        );
                      });
                      stream = calculateData();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.border, width: 1),
                      color: AppColors.surfaceVariant,
                    ),
                    child: Icon(Icons.keyboard_arrow_right, size: 32),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  debugPrint('monthly error: ${snapshot.error}');
                  return Expanded(
                    child: const Center(child: Text('Something went wrong')),
                  );
                }
                if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return Expanded(child: const Center(child: Text('No Data Available')));
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dasboardData.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppRadius.lg),
                                    border: Border.all(color: AppColors.border, width: 1),
                                    color: AppColors.surfaceVariant,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: CustomSize.defaultPadding,
                                        ),
                                        child: Icon(
                                          dasboardData[index]['icon'],
                                          color: dasboardData[index]['color'],
                                          size: 36,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dasboardData[index]['title'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            dasboardData[index]['amount'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: (index == 0)
                                                  ? dasboardData[index]['color']
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Transactions :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: transactionDatails.length,
                            itemBuilder: (context, index1) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(AppRadius.lg),
                                        topRight: Radius.circular(AppRadius.lg),
                                      ),
                                      border: Border.all(
                                        color: AppColors.border,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Icon(
                                            Icons.calendar_month,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          transactionDatails[index1]['date'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(AppRadius.lg),
                                        bottomRight: Radius.circular(AppRadius.lg),
                                      ),
                                      border: Border.all(
                                        color: AppColors.border,
                                        width: 1,
                                      ),
                                      color: AppColors.surface,
                                    ),
                                    child: ListView.builder(
                                      itemCount:
                                          transactionDatails[index1]['transactions']
                                              .length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index2) {
                                        return Container(
                                          margin: EdgeInsets.all(4),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.lg,
                                            ),
                                            border: Border.all(
                                              color: AppColors.border,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 16.0,
                                                ),
                                                child: Icon(
                                                  transactionDatails[index1]['transactions'][index2]['categoryIcon'],
                                                  size: 32,
                                                  color:
                                                      transactionDatails[index1]['transactions'][index2]['categoryColor'],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      transactionDatails[index1]['transactions'][index2]['title'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors.textPrimary,
                                                      ),
                                                    ),
                                                    Text(
                                                      transactionDatails[index1]['transactions'][index2]['time'],
                                                      style: TextStyle(
                                                        color: AppColors.textSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  '${(!transactionDatails[index1]['transactions'][index2]['isIncome']) ? '−' : '+'} LKR ${transactionDatails[index1]['transactions'][index2]['amount'].toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color:
                                                        (!transactionDatails[index1]['transactions'][index2]['isIncome'])
                                                        ? AppColors.expense
                                                        : AppColors.income,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
