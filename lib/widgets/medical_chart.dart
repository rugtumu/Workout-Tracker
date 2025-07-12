import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitness_tracker/models/medical_data.dart';
import 'package:intl/intl.dart';

class MedicalChart extends StatelessWidget {
  final String dataType;
  final List<MedicalData> medicalData;

  const MedicalChart({
    super.key,
    required this.dataType,
    required this.medicalData,
  });

  @override
  Widget build(BuildContext context) {
    if (medicalData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort data by date
    final sortedData = List<MedicalData>.from(medicalData)
      ..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    // Get the last 15 data points for the chart
    final recentData = sortedData.take(15).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dataType,
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
                    horizontalInterval: _getInterval(recentData),
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
                          if (value.toInt() >= recentData.length) {
                            return const Text('');
                          }
                          final data = recentData[value.toInt()];
                          final date = DateTime.parse(data.date);
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
                        interval: _getInterval(recentData),
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toStringAsFixed(1),
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
                  maxX: (recentData.length - 1).toDouble(),
                  minY: _getMinValue(recentData) - _getRange(recentData) * 0.1,
                  maxY: _getMaxValue(recentData) + _getRange(recentData) * 0.1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _createSpots(recentData),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          _getColorForType(dataType).withOpacity(0.8),
                          _getColorForType(dataType).withOpacity(0.3),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: _getColorForType(dataType),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            _getColorForType(dataType).withOpacity(0.3),
                            _getColorForType(dataType).withOpacity(0.1),
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
                  'Latest: ${recentData.last.value}${recentData.last.unit != null ? ' ${recentData.last.unit}' : ''}',
                  style: TextStyle(
                    color: _getColorForType(dataType),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (recentData.length > 1)
                  Text(
                    'Change: ${_getValueChange(recentData)}${recentData.last.unit != null ? ' ${recentData.last.unit}' : ''}',
                    style: TextStyle(
                      color: _getValueChange(recentData) >= 0 ? Colors.green : Colors.red,
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

  List<FlSpot> _createSpots(List<MedicalData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final medicalData = entry.value;
      return FlSpot(index.toDouble(), medicalData.value);
    }).toList();
  }

  double _getMinValue(List<MedicalData> data) {
    if (data.isEmpty) return 0;
    return data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue(List<MedicalData> data) {
    if (data.isEmpty) return 100;
    return data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
  }

  double _getRange(List<MedicalData> data) {
    return _getMaxValue(data) - _getMinValue(data);
  }

  double _getInterval(List<MedicalData> data) {
    final range = _getRange(data);
    if (range <= 10) return 1;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    return range / 10;
  }

  double _getValueChange(List<MedicalData> data) {
    if (data.length < 2) return 0;
    final first = data.first.value;
    final last = data.last.value;
    return (last - first).toDouble();
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'weight':
        return Colors.blue;
      case 'height':
        return Colors.green;
      case 'body fat':
      case 'bodyfat':
        return Colors.orange;
      case 'blood pressure':
      case 'bp':
        return Colors.red;
      case 'heart rate':
      case 'hr':
        return Colors.purple;
      case 'vitamin d':
      case 'vitamin d3':
        return Colors.yellow;
      case 'cholesterol':
        return Colors.teal;
      case 'blood sugar':
        return Colors.pink;
      case 'bmi':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
} 