import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/widgets/income_expense_bar_chart.dart';

class AnnualExpenseTrendChart extends StatefulWidget {
  final double screenWidth;
  const AnnualExpenseTrendChart({super.key, required this.screenWidth});

  @override
  State<AnnualExpenseTrendChart> createState() => _AnnualExpenseTrendChartState();
}

class _AnnualExpenseTrendChartState extends State<AnnualExpenseTrendChart> {
  late final GetChartData object;
  late final Future<List<BarChartGroupData>> chartData;

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

  @override
  void initState() {
    super.initState();
    object = GetChartData(isExpense: true, screenWidth: widget.screenWidth);
    chartData = object.getChartData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<BarChartGroupData>>(
      future: chartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return SizedBox(height: 180, child: Center(child: Text('Somthing went wrong')));
        }
        if (snapshot.data == null || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(height: 180, child: Center(child: Text('No Data Available')));
        }

        final spots = List.generate(
          object.monthlyTotal.length,
          (index) => FlSpot(index.toDouble(), object.monthlyTotal[index]),
        );

        final double rawMax = object.monthlyTotal.reduce(
          (value, element) => value > element ? value : element,
        );
        final double chartMaxY = rawMax <= 0 ? 1000 : (rawMax / 1000).ceil() * 1000.0;
        final double yInterval = chartMaxY / 5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Annual Monthly Expense Trend',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 12,
                  minY: 0,
                  maxY: chartMaxY,

                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      axisNameSize: 20,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: yInterval,
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
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
      },
    );
  }
}
