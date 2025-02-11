import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/home/models/dashboard_models.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';
import 'dart:math' as math;
import '../../services/dashboard_service.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenWidgetState createState() => _ReportScreenWidgetState();
}

class _ReportScreenWidgetState extends State<ReportScreen> {
  int _activeDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/bg/auth_bg.png',
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTransparentContainer(
                    child: SingleChildScrollView(
                      child: BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          if (state is DashboardLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is DashboardLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader(),
                                SizedBox(height: 20),
                                _buildWeeklyReport(state, context),
                                SizedBox(height: 20),
                                _buildCategoryChart(),
                                // SizedBox(height: 20),
                                // _categoryBarChart(),
                                SizedBox(height: 20),
                                // _buildCategoryChart(),
                                // SizedBox(height: 20),
                                // _barChart() ,
                                GestureDetector(
                                  onTap: () {
                                    _downloadReport();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: ColorPallete.gradient,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 8,
                                            spreadRadius: 2),
                                      ],
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Download Report',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Center(child: Text('Something went wrong!'));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Report",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(Icons.notifications, size: 28),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizCard(String day, bool completed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      width: 90,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          Text(day),
          SizedBox(height: 8), // Add space between text and progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(16), // Rounded corners
            child: LinearProgressIndicator(
              value: completed
                  ? 1.0
                  : 0.6, // Use completed status to set the progress
              color: Colors.green,
              backgroundColor: Colors.grey.withOpacity(0.2),
              minHeight: 8, // Adjust the height of the progress bar
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryChart() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Text(
  //               "Recent Quizzes",
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14),
  //             ),
  //             Spacer(),
  //             // Card with an icon in the center
  //             Container(
  //               margin: EdgeInsets.symmetric(horizontal: 12),
  //               width: 30,
  //               height: 30,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Colors.grey.withOpacity(0.2),
  //                       blurRadius: 8,
  //                       spreadRadius: 2),
  //                 ],
  //                 borderRadius: BorderRadius.circular(5),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0), // Padding inside the card
  //                 child: Icon(
  //                   Icons.table_rows_outlined,
  //                   size: 14,
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.symmetric(horizontal: 3),
  //               padding: EdgeInsets.all(8),
  //               height: 30,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Colors.grey.withOpacity(0.2),
  //                       blurRadius: 8,
  //                       spreadRadius: 2),
  //                 ],
  //                 borderRadius: BorderRadius.circular(5),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment:
  //                     MainAxisAlignment.center, // Center align the row content
  //                 children: [
  //                   Text(
  //                     "Week Wise",
  //                     style: TextStyle(color: Colors.black, fontSize: 12),
  //                   ),
  //                   SizedBox(
  //                       width:
  //                           4), // Optional: Add some space between text and icon
  //                   Icon(Icons.keyboard_arrow_down_rounded), // Dropdown icon
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 10), // Space between the rows
  //         // Card with "Week Wise" and dropdown icon
  //       ],
  //     ),
  //   );
  // }

  Widget _buildWeeklyReport(DashboardLoaded state, BuildContext context) {
    final weeklyReport = state.dashboardData.weeklyReport;
    final selectedDay = weeklyReport.days[_activeDayIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Report",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeeklyTabs(),
              SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: "Total screen time : ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: "${selectedDay.totalScreenTime} mins",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildReportTable(state, selectedDay),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _activeDayIndex = index; // Update the active day index on tap
            });
          },
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              gradient: _activeDayIndex == index ? ColorPallete.gradient : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Day ${index + 1}",
              style: TextStyle(
                color: _activeDayIndex == index ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReportTable(DashboardLoaded state, DayReport dayReport) {
    return Table(
      border: TableBorder(
        top: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 1),
        horizontalInside: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 1),
        verticalInside: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 1),
      ),
      children: [
        TableRow(children: [
          _buildTableCell('Activities', isHeader: true),
          _buildTableCell('Status', isHeader: true),
          _buildTableCell('Screen time', isHeader: true),
        ]),
        ...dayReport.activities
            .map((activity) => TableRow(
                  children: [
                    _buildTableCell(activity.activityNumber.toString()),
                    _buildTableCell(activity.status),
                    _buildTableCell(activity.screenTime > 0
                        ? '${activity.screenTime} mins'
                        : '---'),
                  ],
                ))
            .toList(),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isHeader ? 14.0 : 13.0,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _barChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      height: 400, // Set the height of the chart
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80, // Increased reserved size for more space
                getTitlesWidget: (value, meta) {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Transform.rotate(
                        angle: -math.pi / 2, // Rotate text -90 degrees
                        child: Text(
                          _getDayName(value.toInt()), // Get the day name
                          style: TextStyle(
                              fontSize: 12), // Adjust font size if needed
                          textAlign: TextAlign.center, // Center align text
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false, // Remove the border
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 4, color: Colors.blue, width: 16),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 8, color: Colors.red, width: 16),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 5, color: Colors.green, width: 16),
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: 5, color: Colors.yellow, width: 16),
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(toY: 4, color: Colors.purple, width: 16),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _categoryBarChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      height: 400, // Set the height of the chart
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80, // Increased reserved size for more space
                getTitlesWidget: (value, meta) {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Transform.rotate(
                        angle: -math.pi / 2, // Rotate text -90 degrees
                        child: Text(
                          _getDayName(value.toInt()), // Get the day name
                          style: TextStyle(
                              fontSize: 12), // Adjust font size if needed
                          textAlign: TextAlign.center, // Center align text
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false, // Remove the border
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 4, color: Colors.black, width: 16),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 8, color: Colors.blue, width: 16),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 5, color: Colors.green, width: 16),
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: 5, color: Colors.blueAccent, width: 16),
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(toY: 4, color: Colors.black, width: 16),
            ]),
          ],
        ),
      ),
    );
  }

// Function to get day names based on the index
  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'Creative\nThinking';
      case 1:
        return 'Logical\nReasoning';
      case 2:
        return 'Storytelling';
      case 3:
        return 'Vocabulary';
      case 4:
        return 'Vocabulary'; // Note: This case is duplicated, consider changing one
      default:
        return '';
    }
  }

  Widget _buildCategoryChart() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          final activityStats = state.dashboardData.activityTypeStats;

          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2)
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Activity Categories",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 15),
                ...activityStats
                    .map((stat) => Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  stat.label.toLowerCase().capitalizeFirst ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "${stat.completed}/${stat.total}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: stat.percentage / 100,
                                backgroundColor: _getCategoryColor(stat.label)
                                    .withOpacity(0.2),
                                color: _getCategoryColor(stat.label),
                                minHeight: 15,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ))
                    .toList(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case "CREATIVE THINKING":
        return Colors.blue;
      case "LOGICAL REASONING":
        return Colors.green;
      case "STORY TELLING":
        return Colors.orange;
      case "VOCABULARY":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _downloadReport() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 16),
              Text('Downloading report...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      await DashboardService.downloadReport();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report downloaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download report: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
