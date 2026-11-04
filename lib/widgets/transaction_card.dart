import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String categoryName;
  final String price;
  final String dateTime;
  final IconData categoryIcon;
  final bool isExpense;
  final Color categoryColor;
  const TransactionCard({
    super.key,
    required this.title,
    required this.categoryName,
    required this.price,
    required this.dateTime,
    required this.categoryIcon,
    required this.isExpense,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CustomSize.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(categoryIcon, size: 36, color: categoryColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${(isExpense) ? '-' : '+'} LKR $price',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: (isExpense) ? AppColors.expense : AppColors.income,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryName,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        dateTime,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
