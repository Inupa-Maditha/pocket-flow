import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/services/transaction_service.dart';
import 'package:pocket_flow/shared/shared_data.dart';
import 'package:pocket_flow/widgets/transaction_card.dart';
import 'package:pocket_flow/widgets/transaction_filter_dash_board.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({super.key});

  @override
  State<DisplayTransactionsPage> createState() => _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState extends State<DisplayTransactionsPage> {
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: CustomSize.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              'View and manage your income and expenses',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 36),
              child: TransactionFilterDashBoard(),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: SharedData.transactions,
                builder: (context, value, child) {
                  return (value.isEmpty)
                      ? Center(child: Text('No Data Available'))
                      : ListView.builder(
                          itemCount: value.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> item = value[index];
                            final Widget card = Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onLongPress: () {
                                  setState(() {
                                    selectedId = item['id'].toString();
                                  });
                                  Scaffold.of(context)
                                      .showBottomSheet((context) {
                                        return Container(
                                          height: 180,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.lg,
                                            ),
                                            color: AppColors.surfaceVariant,
                                            border: Border.all(color: AppColors.border),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Do you want to delete this transaction?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await TransactionService.deleteTransaction(
                                                        item['id'],
                                                      );
                                                      SharedData.setTransactions =
                                                          SharedData.transactions.value
                                                              .where(
                                                                (transaction) =>
                                                                    transaction['id'] !=
                                                                    item['id'],
                                                              )
                                                              .toList();
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              'Transaction Deleted',
                                                            ),
                                                            backgroundColor: Colors.green,
                                                            duration: const Duration(
                                                              seconds: 2,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                    topLeft:
                                                                        Radius.circular(
                                                                          8,
                                                                        ),
                                                                    topRight:
                                                                        Radius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: AppColors.expense,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                            ],
                                          ),
                                        );
                                      })
                                      .closed
                                      .then((value) {
                                        if (mounted) setState(() => selectedId = null);
                                      });
                                },
                                child: TransactionCard(
                                  title: item['title'],
                                  categoryName: item['categoryName'],
                                  price: (item['price'] as double).toStringAsFixed(2),
                                  dateTime: item['time'],
                                  categoryIcon: IconData(
                                    item['categoryIcon'],
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  isExpense: item['isExpense'],
                                  categoryColor: Color(
                                    int.parse('0xff${item['categoryColor']}'),
                                  ),
                                  bgColor: (selectedId == item['id'].toString())
                                      ? AppColors.expense.withValues(alpha: 0.2)
                                      : AppColors.surfaceVariant,
                                ),
                              ),
                            );
                            return (index == 0 ||
                                    value[index - 1]['date'] != item['date'])
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          item['date'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      card,
                                    ],
                                  )
                                : card;
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
