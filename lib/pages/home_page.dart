import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/models/category_model.dart';
import 'package:pocket_flow/pages/display_transactions_page.dart';
import 'package:pocket_flow/services/category_service.dart';
import 'package:pocket_flow/services/transaction_service.dart';
import 'package:pocket_flow/widgets/main_dashboard.dart';
import 'package:pocket_flow/widgets/annual_expense_trend_chart.dart';
import 'package:pocket_flow/widgets/recent_transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _refreshCount = 0;

  Future<void> _refresh() async {
    setState(() => _refreshCount++);
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            MainDashboard(key: ValueKey('dash$_refreshCount')),
            const SizedBox(height: 25),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    AnnualExpenseTrendChart(
                      key: ValueKey('chart$_refreshCount'),
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayTransactionsPage(),
                              ),
                            );
                            if (mounted) setState(() => _refreshCount++);
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder(
                      stream: TransactionService.getRecentTransactions(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No Transactions',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index].toMap();
                            final dateTime = (data['dateTime'] as Timestamp).toDate();
                            final date = DateFormat('yyyy-MM-dd').format(dateTime);
                            final time = DateFormat('HH:mm').format(dateTime);

                            return FutureBuilder<CategoryModel?>(
                              future: CategoryService.getCategoryByID(data['categoryId']),
                              builder: (context, categorySnapshot) {
                                if (categorySnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: 50,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                if (!categorySnapshot.hasData) {
                                  return const SizedBox.shrink();
                                }
                                return RecentTransactionCard(
                                  isIncome: !data['isExpense'],
                                  transactionAmmount: data['transactionAmount'],
                                  category: categorySnapshot.data!
                                      .toMap()['categoryName'],
                                  description: data['title'],
                                  dateAndTime: '$date $time',
                                  categoryIcon: categorySnapshot.data!
                                      .toMap()['categoryIcon'],
                                  categoryColor: categorySnapshot.data!
                                      .toMap()['categoryColor'],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
