import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/widgets/income_expense_bar_chart.dart';
import 'package:pocket_flow/widgets/income_expense_category_card.dart';

class ExpensesRecordPage extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;
  const ExpensesRecordPage({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IncomeExpenseBarChart(isExpence: true),
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
              itemCount: dataList.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: CustomSize.defaultPadding),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final selectedData = dataList[index];
                return IncomeExpenseCategoryCard(
                  isIncome: false,
                  ammount: (selectedData['amount'] as double).toStringAsFixed(2),
                  transactionCount: selectedData['count'].toString(),
                  categoryName: selectedData['title'],
                  categoryId: selectedData['id'],
                  categoryIcon: selectedData['icon'],
                  categoryColor: selectedData['color'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
