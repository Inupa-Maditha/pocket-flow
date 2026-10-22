import 'package:flutter/material.dart';
import 'package:pocket_flow/pages/expenses_record_page.dart';
import 'package:pocket_flow/pages/income_record_page.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Container(
              height: 68,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 1.25),
              ),
              child: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.trending_up_rounded), text: 'Income'),
                  Tab(icon: Icon(Icons.trending_down_rounded), text: 'Expenses'),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(color: Color.fromARGB(228, 112, 167, 255)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                dividerColor: Colors.transparent,
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: IncomeRecordPage()),
            Center(child: ExpensesRecordPage()),
          ],
        ),
      ),
    );
  }
}
