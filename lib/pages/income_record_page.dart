import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/pages/create_new_category.dart';
import 'package:pocket_flow/widgets/income_expense_bar_chart.dart';
import 'package:pocket_flow/widgets/income_expense_category_card.dart';

class IncomeRecordPage extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;
  final Future<void> Function() onRefresh;
  const IncomeRecordPage({super.key, required this.dataList, required this.onRefresh});

  @override
  State<IncomeRecordPage> createState() => _IncomeRecordPageState();
}

class _IncomeRecordPageState extends State<IncomeRecordPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IncomeExpenseBarChart(
                isExpence: false,
                screenWidth: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Income Categories :',
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
                  final Map<String, dynamic> selectedData = widget.dataList[index];
                  return InkWell(
                    onLongPress: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewCategory(
                            isExpense: false,
                            isEditMode: true,
                            selectedCategoryData: selectedData,
                          ),
                        ),
                      );
                      await widget.onRefresh();
                    },
                    child: IncomeExpenseCategoryCard(
                      isIncome: true,
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
