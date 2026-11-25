import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/models/transaction_model.dart';
import 'package:pocket_flow/services/transaction_service.dart';

class IncomeExpenseBarChart extends StatefulWidget {
  final bool isExpence;
  final double screenWidth;

  const IncomeExpenseBarChart({
    super.key,
    required this.isExpence,
    required this.screenWidth,
  });

  @override
  State<IncomeExpenseBarChart> createState() => _IncomeExpenceBarChartState();
}

class _IncomeExpenceBarChartState extends State<IncomeExpenseBarChart> {
  late Future<List<BarChartGroupData>> stream;
  late GetChartData chartData;

  @override
  void initState() {
    super.initState();
    chartData = GetChartData(
      isExpense: widget.isExpence,
      screenWidth: widget.screenWidth,
    );
    stream = chartData.getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            "Monthly ${(widget.isExpence) ? "Expence" : "Income"} Chart :  ${DateTime.now().year.toString()}",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ),
        FutureBuilder<List<BarChartGroupData>>(
          future: stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              debugPrint('Chart error: ${snapshot.error}');
              return Center(child: Text('Somthing went wrong'));
            }

            if ((chartData.maxY == 0) || !snapshot.hasData) {
              return SizedBox(
                height: 80,
                child: Center(child: Text('No Data Available')),
              );
            }

            return SizedBox(
              width: widget.screenWidth - 24,
              height: 180,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(enabled: true),
                  alignment: BarChartAlignment.spaceEvenly,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                  ),
                  maxY: (chartData.maxY * 1.2),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          Widget text(String text) {
                            return Text(text, style: TextStyle(fontSize: 12));
                          }

                          switch (value.toInt()) {
                            case 1:
                              return text('Jan');
                            case 2:
                              return text('Feb');
                            case 3:
                              return text('Mar');
                            case 4:
                              return text('Apr');
                            case 5:
                              return text('May');
                            case 6:
                              return text('Jun');
                            case 7:
                              return text('Jul');
                            case 8:
                              return text('Aug');
                            case 9:
                              return text('Sep');
                            case 10:
                              return text('Oct');
                            case 11:
                              return text('Nov');
                            case 12:
                              return text('Dec');
                            default:
                              return text('');
                          }
                        },
                      ),
                    ),
                  ),
                  barGroups: snapshot.data,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class GetChartData {
  final bool isExpense;
  final double screenWidth;
  double maxY = 0.0;
  List<double> monthlyTotal = List.filled(12, 0.0);
  GetChartData({required this.isExpense, required this.screenWidth});

  Future<List<BarChartGroupData>> getChartData() async {
    monthlyTotal = List.filled(12, 0.0);
    List<BarChartGroupData> chartDataList = [];

    final DateTime this_ = DateTime.now();

    final List<TransactionModel> models =
        await TransactionService.getFilteredTransactions(
          DateTime(this_.year, 1, 1, 0, 0, 0),
          this_,
          null,
          isExpense,
        )!.first;

    for (var i = 0; i < models.length; i++) {
      final int monthIndex = models[i].dateTime.month - 1;

      monthlyTotal[monthIndex] += models[i].transactionAmount;
    }

    maxY = monthlyTotal.reduce((a, b) => a > b ? a : b);

    BarChartGroupData makeBarGroup(int x, double y) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            color: (isExpense) ? AppColors.expense : AppColors.income,
            width: screenWidth / 24,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }

    for (var i = 0; i < 12; i++) {
      chartDataList.add(makeBarGroup(i + 1, monthlyTotal[i]));
    }

    return chartDataList;
  }
}
