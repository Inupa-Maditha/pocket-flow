import 'package:flutter/material.dart';

class RecentTransactionCard extends StatelessWidget {
  const RecentTransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIncome = true;
    double transactionAmmount = 2000;
    String category = 'Food & Dining';
    String description = 'Dinner at resturant';
    String dateAndTime = '2026-10-19 18:45';
    // ignore: dead_code
    String mark = (isIncome) ? '+' : '-';
    return Column(
      children: [
        Divider(color: Colors.grey, thickness: 1.25),
        Row(
          children: [
            Icon(Icons.food_bank, size: 54, color: Colors.blue),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '$mark LKR ${transactionAmmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // ignore: dead_code
                          color: (isIncome) ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(description), Text(dateAndTime)],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey, thickness: 1.25),
      ],
    );
  }
}
