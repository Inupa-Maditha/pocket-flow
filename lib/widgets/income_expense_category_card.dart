import 'package:flutter/material.dart';

class IncomeExpenseCategoryCard extends StatelessWidget {
  final bool isIncome;
  final String ammount;
  final String transactionCount;
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  const IncomeExpenseCategoryCard({
    super.key,
    required this.isIncome,
    required this.ammount,
    required this.transactionCount,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Icon(categoryIcon, size: 54, color: categoryColor)],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: categoryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$transactionCount transactions'),
                      Text(
                        'LKR $ammount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (isIncome) ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.keyboard_arrow_right, size: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
