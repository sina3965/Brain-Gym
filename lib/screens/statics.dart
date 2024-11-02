import 'package:bg/models/test.dart';
import 'package:bg/providers/exercise_provider.dart';
import 'package:bg/providers/session_provider.dart';
import 'package:bg/providers/test_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class Statics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // فراخوانی تابع برای دریافت تمرینات از جلسه روز جاری
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var sessionProvider = context.read<SessionProvider>();
      var exerciseProvider = context.read<ExerciseProvider>();

      exerciseProvider.updateProviders(sessionProvider);
      exerciseProvider.fetchAllExercisesFromSessions().then((_) {
        // بررسی تعداد تمرینات بارگذاری شده
        print("Loaded Exercises: ${exerciseProvider.exercises.length}");
      });
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(child: Text('نمودار نتایج')),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('نتایج تمرینات', style: TextStyle(fontSize: 20)), // اصلاح اندازه فونت
                SizedBox(height: 20),
                Container(
                  height: 500,
                  width: double.infinity, // تغییر به عرض کامل
                  child: Consumer<ExerciseProvider>(
                    builder: (context, exerciseProvider, child) {
                      if (exerciseProvider.exercises.isEmpty) {
                        return Center(child: Text('No data available'));
                      }

                      // تبدیل داده‌های تمرینات به FlSpot برای نمایش در نمودار
                      List<FlSpot> exerciseSpots = exerciseProvider.exercises
                          .asMap()
                          .entries
                          .map((entry) {
                        // تبدیل زمان ثبت شده به ثانیه
                        int xValue = convertTimeToSeconds(entry.value.record);
                        double yValue = entry.key.toDouble();  // روزها به عنوان Y
                        print('Exercise ID: ${entry.value.id}, Record (seconds): $xValue');
                        return FlSpot(xValue.toDouble(), yValue);
                      }).toList();

                      // پیدا کردن بیشترین مقدار X (زمان) برای تنظیم maxX
                      double maxXValue = exerciseSpots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b) + 30;

                      return LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: maxXValue,
                          minY: 0,
                          maxY: exerciseSpots.length.toDouble(),
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 30,
                                getTitlesWidget: (value, meta) {
                                  int minutes = (value ~/ 60).toInt();
                                  int seconds = (value % 60).toInt();
                                  return Text('$minutes:${seconds.toString().padLeft(2, '0')}', style: TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return Text('Day ${value.toInt() + 1}', style: TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: exerciseSpots,
                              isCurved: true,
                              color: Colors.blue,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int convertTimeToSeconds(String time) {
    List<String> parts = time.split(':');
    if (parts.length == 2) {
      int minutes = int.tryParse(parts[0]) ?? 0;
      int seconds = int.tryParse(parts[1]) ?? 0;
      return (minutes * 60) + seconds;
    }
    return 0;
  }
}

