import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodStatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Statistics'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Trends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 5, color: Colors.green)
                    ], showingTooltipIndicators: [0]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 3, color: Colors.blue)
                    ], showingTooltipIndicators: [0]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 7, color: Colors.red)
                    ], showingTooltipIndicators: [0]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 2, color: Colors.orange)
                    ], showingTooltipIndicators: [0]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(toY: 8, color: Colors.purple)
                    ], showingTooltipIndicators: [0]),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          List<String> moods = ['😀', '😐', '😢', '😡', '😴'];
                          return Text(moods[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
