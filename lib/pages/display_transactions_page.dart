import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/widgets/transaction_card.dart';
import 'package:pocket_flow/widgets/transaction_filter_dash_board.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({super.key});

  @override
  State<DisplayTransactionsPage> createState() => _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState extends State<DisplayTransactionsPage> {
  final categoryName = 'Food & Dining';
  final categoryIcon = Icons.cake;
  final transactionName = 'Breakfast';
  final date = '2026-07-13';
  final time = '14.28';
  final isExpense = false;
  final price = 1500.8;
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
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 36),
              child: TransactionFilterDashBoard(),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TransactionCard(
                                  title: transactionName,
                                  categoryName: categoryName,
                                  price: (price).toStringAsFixed(2),
                                  dateTime: time,
                                  categoryIcon: Icons.cake,
                                  isExpense: isExpense,
                                  categoryColor: Colors.blue,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
