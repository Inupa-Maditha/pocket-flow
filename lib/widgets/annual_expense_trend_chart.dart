import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnnualExpenseTrendChart extends StatelessWidget {
  const AnnualExpenseTrendChart({super.key});

  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<double> expenses = [
    1200,
    1800,
    1500,
    2400,
    2100,
    3200,
    2800,
    3500,
    2600,
    4100,
    3700,
    4500,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final spots = List.generate(
      expenses.length,
      (index) => FlSpot(index.toDouble(), expenses[index]),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Annual Monthly Expense Trend',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 260,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 12,
              minY: 0,
              maxY: 5000,

              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 32,

                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 ||
                          index >= months.length ||
                          value != index.toDouble()) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          months[index],
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),

                leftTitles: AxisTitles(
                  axisNameWidget: const Text(
                    'LKR',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  axisNameSize: 20,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1000,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        space: 4,
                        child: Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),

              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final month = months[spot.x.toInt()];
                      final amount = spot.y.toStringAsFixed(2);

                      return LineTooltipItem(
                        '$month\nLKR $amount',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    }).toList();
                  },
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,

                  dotData: const FlDotData(show: false),

                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withAlpha(180),
                        Colors.blueAccent.withAlpha(60),
                      ],
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
