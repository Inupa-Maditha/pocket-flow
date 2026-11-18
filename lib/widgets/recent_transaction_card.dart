import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';

class RecentTransactionCard extends StatelessWidget {
  final bool isIncome;
  final double transactionAmmount;
  final String category;
  final int categoryIcon;
  final String categoryColor;
  final String description;
  final String dateAndTime;
  const RecentTransactionCard({
    super.key,
    required this.isIncome,
    required this.transactionAmmount,
    required this.category,
    required this.description,
    required this.dateAndTime,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final String finalCategoryColor = '0xFF$categoryColor';
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8, top: 8, right: 12),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(
                  IconData(categoryIcon, fontFamily: 'MaterialIcons'),
                  size: 38,
                  color: Color(int.parse(finalCategoryColor)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${isIncome ? '+' : '-'} LKR ${transactionAmmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (isIncome) ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          description,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        Text(
                          dateAndTime,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
