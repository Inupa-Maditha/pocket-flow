import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/widgets/income_expense_bar_chart.dart';
import 'package:pocket_flow/widgets/income_expense_category_card.dart';

class IncomeRecordPage extends StatelessWidget {
  const IncomeRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IncomeExpenseBarChart(isExpence: false),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Income Categories :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: CustomSize.defaultPadding),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return IncomeExpenseCategoryCard(
                    isIncome: true,
                    ammount: '28500.00',
                    transactionCount: '29',
                    categoryName: 'Food & Dining',
                    categoryIcon: Icons.food_bank_sharp,
                    categoryColor: Colors.blueAccent,
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
