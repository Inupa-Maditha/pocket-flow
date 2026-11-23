import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/pages/create_new_category.dart';
import 'package:pocket_flow/widgets/income_expense_bar_chart.dart';
import 'package:pocket_flow/widgets/income_expense_category_card.dart';

class ExpensesRecordPage extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;
  const ExpensesRecordPage({super.key, required this.dataList});

  @override
  State<ExpensesRecordPage> createState() => _ExpensesRecordPageState();
}

class _ExpensesRecordPageState extends State<ExpensesRecordPage> {
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
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IncomeExpenseBarChart(
                isExpence: true,
                screenWidth: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Expense Categories :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              ListView.builder(
                itemCount: widget.dataList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: CustomSize.defaultPadding),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final selectedData = widget.dataList[index];
                  return InkWell(
                    onLongPress: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewCategory(
                            isExpense: true,
                            isEditMode: true,
                            categoryId: selectedData['id'],
                          ),
                        ),
                      );
                      if (mounted) setState(() => _refreshCount++);
                    },
                    child: IncomeExpenseCategoryCard(
                      key: ValueKey('ecc$_refreshCount'),
                      isIncome: false,
                      ammount: (selectedData['amount'] as double).toStringAsFixed(2),
                      transactionCount: selectedData['count'].toString(),
                      categoryName: selectedData['title'],
                      categoryId: selectedData['id'],
                      categoryIcon: selectedData['icon'],
                      categoryColor: selectedData['color'],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
