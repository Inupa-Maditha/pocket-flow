import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseBarChart extends StatefulWidget {
  final bool isExpence;
  const IncomeExpenseBarChart({super.key, required this.isExpence});

  @override
  State<IncomeExpenseBarChart> createState() => _IncomeExpenceBarChartState();
}

class _IncomeExpenceBarChartState extends State<IncomeExpenseBarChart> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    BarChartGroupData makeBarGroup(int x, double y) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            color: (widget.isExpence) ? Colors.red : Colors.green,
            width: screenWidth / 24,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            "Monthly ${(widget.isExpence) ? "Expence" : "Income"} Chart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: screenWidth - 24,
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
              maxY: (18 + 18 * 1 / 5),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 1:
                          return const Text('Jan');
                        case 3:
                          return const Text('Mar');
                        case 5:
                          return const Text('May');
                        case 7:
                          return const Text('Jul');
                        case 9:
                          return const Text('Sap');
                        case 11:
                          return const Text('Now');
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
              ),
              barGroups: [
                makeBarGroup(1, 15),
                makeBarGroup(2, 5),
                makeBarGroup(3, 18),
                makeBarGroup(4, 9),
                makeBarGroup(5, 12),
                makeBarGroup(6, 15),
                makeBarGroup(7, 5),
                makeBarGroup(8, 18),
                makeBarGroup(9, 9),
                makeBarGroup(10, 5),
                makeBarGroup(11, 18),
                makeBarGroup(12, 9),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
