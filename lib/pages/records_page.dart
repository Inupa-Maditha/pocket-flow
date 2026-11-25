import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/models/category_model.dart';
import 'package:pocket_flow/models/transaction_model.dart';
import 'package:pocket_flow/pages/expenses_record_page.dart';
import 'package:pocket_flow/pages/income_record_page.dart';
import 'package:pocket_flow/services/category_service.dart';
import 'package:pocket_flow/services/transaction_service.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late Future<List<dynamic>> recordsFuture;
  int _refreshCount = 0;

  Future<void> _refresh() async {
    setState(() => _refreshCount++);
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _reload() async {
    setState(() {
      recordsFuture = getData();
    });
    await recordsFuture;
  }

  Future<List<Map<String, dynamic>>> getMonthlyTransactionObjectData() async {
    final List<TransactionModel> models =
        await TransactionService.getTransactionByDateRange(
          DateTime(DateTime.now().year, DateTime.now().month, 1, 0, 0),
          DateTime.now(),
        ).first;
    final List<Map<String, dynamic>> data = [];
    for (var element in models) {
      data.add(element.toMap());
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getCategoriesObjectData(bool isExpense) async {
    final List<CategoryModel> models = await CategoryService.getCategoriesByType(
      isExpense,
    ).first;
    final List<Map<String, dynamic>> data = [];
    for (var element in models) {
      data.add(element.toMap());
    }
    return data;
  }

  Future<List> getData() async {
    final List<Map<String, dynamic>> transaction =
        await getMonthlyTransactionObjectData();
    final List<Map<String, dynamic>> expenses = await getCategoriesObjectData(true);
    final List<Map<String, dynamic>> incomes = await getCategoriesObjectData(false);
    final Map<String, Map<String, dynamic>> summary = {};

    for (final category in [...incomes, ...expenses]) {
      summary[category['id']] = {'count': 0, 'amount': 0.0};
    }

    for (final item in transaction) {
      final categoryId = item['categoryId'];
      if (!summary.containsKey(categoryId)) continue;
      summary[categoryId]!['count']++;
      summary[categoryId]!['amount'] += (item['transactionAmount'] as num).toDouble();
    }

    final List<Map<String, dynamic>> incomeData = incomes.map((category) {
      final result = summary[category['id']]!;

      return {
        'id': category['id'],
        'title': category['categoryName'] as String,
        'icon': category['categoryIcon'] as int,
        'color': category['categoryColor'] as String,
        'count': result['count'] as int,
        'amount': result['amount'] as double,
      };
    }).toList();

    final List<Map<String, dynamic>> expenseData = expenses.map((category) {
      final result = summary[category['id']]!;

      return {
        'id': category['id'],
        'title': category['categoryName'] as String,
        'icon': category['categoryIcon'] as int,
        'color': category['categoryColor'] as String,
        'count': result['count'] as int,
        'amount': result['amount'] as double,
      };
    }).toList();

    return [incomeData, expenseData];
  }

  @override
  void initState() {
    super.initState();
    recordsFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<dynamic>>(
        future: recordsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No Data Available'));
          }

          final incomeDataMap = snapshot.data![0] as List<Map<String, dynamic>>;
          final expenseDataMap = snapshot.data![1] as List<Map<String, dynamic>>;

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
              body: TabBarView(
                children: [
                  IncomeRecordPage(dataList: incomeDataMap, onRefresh: _reload),
                  ExpensesRecordPage(dataList: expenseDataMap, onRefresh: _reload),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
