import 'package:flutter/material.dart';
import 'dart:math';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/services/transaction_service.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  late Future<Map<String, double>> future;
  double deviceWidth = 0.0;
  double monthlyIncome = 0.0;
  double monthlyExpense = 0.0;
  double accountBalance = 0.0;

  Future<Map<String, double>> getData() async {
    final now = DateTime.now();
    final allTransactionList = await TransactionService.getAllTransaction()!.first;
    final monthlyTransactionList = await TransactionService.getTransactionByDateRange(
      DateTime(now.year, now.month, 1, 0, 0, 0),
      now,
    ).first;

    for (var element in allTransactionList) {
      if (element.isExpense) {
        accountBalance -= element.transactionAmount;
      }
      if (!element.isExpense) {
        accountBalance += element.transactionAmount;
      }
    }
    for (var element in monthlyTransactionList) {
      if (element.isExpense) {
        monthlyExpense += element.transactionAmount;
      }
      if (!element.isExpense) {
        monthlyIncome += element.transactionAmount;
      }
    }
    return {
      'accountBalance': accountBalance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpence': monthlyExpense,
    };
  }

  @override
  void initState() {
    super.initState();
    future = getData();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = max(0.0, MediaQuery.sizeOf(context).width - 24);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Dash Board',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return Center(child: Text('No Data Available'));
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: max(0.0, (deviceWidth - 10) / 6),
                      width: max(0.0, (deviceWidth - 5) / 2),
                      decoration: BoxDecoration(
                        color: AppColors.incomeContainer,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Monthly Income',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LKR :',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    (snapshot.data['monthlyIncome'] as double)
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: AppColors.income,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: max(0.0, (deviceWidth - 10) / 6),
                      width: max(0.0, (deviceWidth - 5) / 2),
                      decoration: BoxDecoration(
                        color: AppColors.expenseContainer,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Monthly Expense',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LKR :',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    (snapshot.data['monthlyExpence'] as double)
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: AppColors.expense,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: max(0.0, deviceWidth / 3),
                      width: max(0.0, (deviceWidth - 5) / 2),
                      decoration: BoxDecoration(
                        color: (accountBalance >= 0)
                            ? AppColors.incomeContainer
                            : AppColors.expenseContainer,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Account Balance',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LKR :',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    (snapshot.data['accountBalance'] as double)
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: (accountBalance >= 0)
                                          ? AppColors.income
                                          : AppColors.expense,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
