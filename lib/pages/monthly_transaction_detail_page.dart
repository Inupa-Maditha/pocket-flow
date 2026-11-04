import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';

class MonthlyTransactionDetailPage extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isIncome;
  const MonthlyTransactionDetailPage({
    super.key,
    required this.categoryName,
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
  // trxDetails

  late double totalSpent;
  late double totalTransactions;
  late double transactionAverage;
  late double dayAverage;
  late int totalDays;
  late DateTime selectedMonth;

  List<Map<String, dynamic>> trxDetails = [
    {
      'date': '2026-11-30',
      'transactions': [
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': true,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': true,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': false,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2000,
        },
      ],
    },
    {
      'date': '2026-11-29',
      'transactions': [
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': false,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
      ],
    },
    {
      'date': '2026-11-28',
      'transactions': [
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': false,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': true,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': true,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
        {
          'categoryName': 'Category One',
          'categoryIcon': Icons.settings,
          'categoryColor': Colors.blue,
          'isIncome': true,
          'time': '11.54',
          'title': 'Lunch',
          'amount': 2400,
        },
      ],
    },
  ];

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
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
              setState(() {
                selectedMonth = DateTime(newDate.year, newDate.month);
              });
            },
          ),
        );
      },
    );
  }

  // ignore: body_might_complete_normally_nullable
  String? _monthSelector(int monthNumber) {
    if (0 < monthNumber && monthNumber < 13) {
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
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    totalSpent = 0;
    totalTransactions = 0;
    totalDays = trxDetails.length;

    for (int i = 0; i < trxDetails.length; i++) {
      for (int j = 0; j < trxDetails[i]['transactions'].length; j++) {
        totalSpent += trxDetails[i]['transactions'][j]['amount'];
      }
    }
    for (int i = 0; i < trxDetails.length; i++) {
      totalTransactions += trxDetails[i]['transactions'].length;
    }

    transactionAverage = totalSpent / totalTransactions;
    dayAverage = totalSpent / totalDays;

    selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dasboardData = [
      {
        'icon': Icons.account_balance_wallet,
        'color': (widget.isIncome) ? AppColors.income : AppColors.expense,
        'title': (widget.isIncome) ? 'Total Earned' : 'Total Spent',
        'amount': 'LKR ${totalSpent.toStringAsFixed(2)}',
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
                          color: widget.categoryColor,
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
                  child: InkWell(
                    onTap: () {
                      _showMonthPicker(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.symmetric(
                        horizontal: CustomSize.defaultPadding,
                        vertical: CustomSize.defaultPadding * 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.border, width: 1),
                        color: AppColors.surfaceVariant,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
            Expanded(
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
                        itemCount: trxDetails.length,
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
                                  border: Border.all(color: AppColors.border, width: 1),
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
                                      trxDetails[index1]['date'],
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
                                  border: Border.all(color: AppColors.border, width: 1),
                                  color: AppColors.surface,
                                ),
                                child: ListView.builder(
                                  itemCount: trxDetails[index1]['transactions'].length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index2) {
                                    return Container(
                                      margin: EdgeInsets.all(4),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(AppRadius.lg),
                                        border: Border.all(
                                          color: AppColors.border,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0),
                                            child: Icon(
                                              trxDetails[index1]['transactions'][index2]['categoryIcon'],
                                              size: 32,
                                              color:
                                                  trxDetails[index1]['transactions'][index2]['categoryColor'],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  trxDetails[index1]['transactions'][index2]['title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  trxDetails[index1]['transactions'][index2]['time'],
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
                                              '${(!trxDetails[index1]['transactions'][index2]['isIncome']) ? '−' : '+'} LKR ${trxDetails[index1]['transactions'][index2]['amount'].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color:
                                                    (!trxDetails[index1]['transactions'][index2]['isIncome'])
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
            ),
          ],
        ),
      ),
    );
  }
}
