import 'package:flutter/material.dart';
import 'package:pocket_flow/pages/display_transactions_page.dart';
import 'package:pocket_flow/widgets/main_dashboard.dart';
import 'package:pocket_flow/widgets/annual_expense_trend_chart.dart';
import 'package:pocket_flow/widgets/recent_transaction_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MainDashboard(),
            SizedBox(height: 25),
            AnnualExpenseTrendChart(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisplayTransactionsPage()),
                    );
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: 5,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return RecentTransactionCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}
