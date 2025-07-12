import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:intl/intl.dart';

class ProgressChart extends StatelessWidget {
  final String exerciseName;
  final List<Workout> workouts;

  const ProgressChart({
    super.key,
    required this.exerciseName,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort workouts by date
    final sortedWorkouts = List<Workout>.from(workouts)
      ..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    // Get the last 10 workouts for the chart
    final recentWorkouts = sortedWorkouts.take(10).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exerciseName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 10,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white24,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white24,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() >= recentWorkouts.length) {
                            return const Text('');
                          }
                          final workout = recentWorkouts[value.toInt()];
                          final date = DateTime.parse(workout.date);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white24),
                  ),
                  minX: 0,
                  maxX: (recentWorkouts.length - 1).toDouble(),
                  minY: 0,
                  maxY: _getMaxWeight(recentWorkouts) + 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _createSpots(recentWorkouts),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.8),
                          Colors.green.withOpacity(0.3),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.green,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.3),
                            Colors.green.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest: ${recentWorkouts.last.weight} kg',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (recentWorkouts.length > 1)
                  Text(
                    'Change: ${_getWeightChange(recentWorkouts)} kg',
                    style: TextStyle(
                      color: _getWeightChange(recentWorkouts) >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _createSpots(List<Workout> workouts) {
    return workouts.asMap().entries.map((entry) {
      final index = entry.key;
      final workout = entry.value;
      return FlSpot(index.toDouble(), workout.weight);
    }).toList();
  }

  double _getMaxWeight(List<Workout> workouts) {
    if (workouts.isEmpty) return 100;
    return workouts.map((w) => w.weight).reduce((a, b) => a > b ? a : b);
  }

  double _getWeightChange(List<Workout> workouts) {
    if (workouts.length < 2) return 0;
    final first = workouts.first.weight;
    final last = workouts.last.weight;
    return (last - first).toDouble();
  }
} 