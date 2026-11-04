import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
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
              margin: const EdgeInsets.all(CustomSize.defaultPadding),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.trending_up_rounded), text: 'Income'),
                  Tab(icon: Icon(Icons.trending_down_rounded), text: 'Expenses'),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                  border: Border.all(color: AppColors.border),
                ),
                indicatorAnimation: TabIndicatorAnimation.elastic,
                labelColor: AppColors.surface,
                unselectedLabelColor: AppColors.textPrimary,
                dividerColor: Colors.transparent,
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [IncomeRecordPage(), ExpensesRecordPage()]),
      ),
    );
  }
}
