import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/modules/home/events/dashboard_events.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/home/models/dashboard_models.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_activity_screen.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreen> {
  int _activeDayIndex = 0;
  late Worker _worker;
  String selectedPeriod = 'Week wise';
  @override
  void initState() {
    super.initState();
    _worker = ever(
      Get.find<Rx<DashboardRefreshEvent>>(tag: 'dashboard_refresh'),
      (_) => context.read<DashboardBloc>().add(LoadDashboardData()),
    );
  }

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }

  String _getLevelFromPercentage(int percentage) {
    if (percentage == 100) return 'Sharp';
    if (percentage >= 70) return 'Strong';
    if (percentage >= 40) return 'Growing';
    return 'Weak';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
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
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (state is DashboardLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildHeader(),
                                    SizedBox(height: 20),
                                    _buildUserStreaks(state),
                                    SizedBox(height: 20),
                                    _buildProgressBars(state),
                                    SizedBox(height: 20),
                                    _buildRecentQuizzes(state),
                                    SizedBox(height: 20),
                                    // _buildCategoryChart(),
                                    // SizedBox(height: 20),
                                    _categoryStatsTable(),
                                    SizedBox(height: 20),
                                    _buildWeeklyReport(state, context)
                                  ],
                                );
                              } else {
                                return Center(
                                    child: Text('Something went wrong!'));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    String userName = LocalStorage.prefs.getString('userProfileData') != null
        ? jsonDecode(LocalStorage.prefs.getString('userProfileData')!)['user']
            ['fullName']
        : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello 👋",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      width: 8, // Circle width
                      height: 8, // Circle height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green, // Circle color
                      ),
                    ),
                    SizedBox(width: 6), // Space between circle and text
                    Text("Online", style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
            // Icon(Icons.notifications, size: 28),
          ],
        ),
        Text("$userName's overview",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildUserStreaks(DashboardLoaded state) {
    final weeklyStreak = state.dashboardData.weeklyStreak;
    final streaks = weeklyStreak.entries.map((entry) {
      final isActive = entry.value;
      return "${entry.key} ${isActive ? '🔥' : '🔥'.toString().replaceAll('🔥', '🔥')}";
    }).toList();

    return Container(
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
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Days streaks",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
              Spacer(),
              Text("This week",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 22),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: streaks.length,
              itemBuilder: (context, index) {
                final isActive = weeklyStreak.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    streaks[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: isActive ? Colors.black : Colors.grey.shade400,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBars(DashboardLoaded state) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Progress",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          SizedBox(
            height: 8,
          ),
          _buildProgressRow(
              "Weekly",
              state.dashboardData.progress.weekly.completed,
              state.dashboardData.progress.weekly.total,
              Colors.green),
          _buildProgressRow(
              "Monthly",
              state.dashboardData.progress.monthly.completed,
              state.dashboardData.progress.monthly.total,
              Colors.yellow),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, int progress, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress/total, progress bar, and label in one row
        Row(
          children: [
            Text("$progress/$total"), // Progress/total on the left
            SizedBox(
                width:
                    15), // Add some space between the text and the progress bar

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: (total != 0) ? (progress / total) : 0,
                      color: color,
                      backgroundColor: color.withOpacity(0.2),
                      minHeight: 15,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${((total != 0) ? (progress / total) * 100 : 0 * 100).toStringAsFixed(0)}%", // Show percentage
                          style: TextStyle(
                            color: Colors.white, // Color of the percentage text
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10), // Add space between progress bar and label

            // Label on the right
            Text(label,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildRecentQuizzes(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Quizzes",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        SizedBox(height: 10),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.dashboardData.recentQuizzes.length,
            itemBuilder: (context, index) {
              return _buildQuizCard(
                  "Day ${state.dashboardData.recentQuizzes[index].dayNumber}",
                  state.dashboardData.recentQuizzes[index].progress >= 100);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizCard(String day, bool completed) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        width: 90,
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
      ),
    );
  }

  // Widget _buildCategoryChart() {
  //   return BlocBuilder<DashboardBloc, DashboardState>(
  //     builder: (context, state) {
  //       if (state is DashboardLoaded) {
  //         final activityStats = state.dashboardData.activityTypeStats;

  //         return Container(
  //           padding: EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.grey.withOpacity(0.2),
  //                   blurRadius: 8,
  //                   spreadRadius: 2)
  //             ],
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Text(
  //                     "Activity Categories",
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                   Spacer(),
  //                 ],
  //               ),
  //               SizedBox(height: 15),
  //               ...activityStats
  //                   .map((stat) => Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 stat.label.toLowerCase().capitalizeFirst ??
  //                                     '',
  //                                 style: TextStyle(
  //                                   color: Colors.grey[600],
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                               Spacer(),
  //                               Text(
  //                                 "${stat.completed}/${stat.total}",
  //                                 style: TextStyle(
  //                                   color: Colors.grey[600],
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(height: 8),
  //                           ClipRRect(
  //                             borderRadius: BorderRadius.circular(12),
  //                             child: LinearProgressIndicator(
  //                               value: stat.percentage / 100,
  //                               backgroundColor: _getCategoryColor(stat.label)
  //                                   .withOpacity(0.2),
  //                               color: _getCategoryColor(stat.label),
  //                               minHeight: 15,
  //                             ),
  //                           ),
  //                           SizedBox(height: 15),
  //                         ],
  //                       ))
  //                   .toList(),
  //             ],
  //           ),
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }

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
      children: List.generate(7, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _activeDayIndex = index;
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

  Widget _categoryStatsTable() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          final activityStats = state.dashboardData.activityTypeStats;

          List<ActivityTypeStat> getSelectedStats() {
            switch (selectedPeriod) {
              case 'Month wise':
                return activityStats.monthlyStats;
              case 'Overall':
                return activityStats.overallStats;
              default:
                return activityStats.weeklyStats;
            }
          }

          final stats = getSelectedStats();

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.bar_chart,
                        size: 18, color: ColorPallete.primary),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedPeriod,
                      underline: const SizedBox(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorPallete.primary),
                      borderRadius: BorderRadius.circular(8),
                      items: ['Week wise', 'Month wise', 'Overall']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPeriod = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1.2),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Category",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                        ),
                        Text("Questions",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("Level",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                        ),
                      ],
                    ),
                    ...stats.map((stat) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              stat.label,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            "${stat.completed}/${stat.total}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _getLevelFromPercentage(stat.percentage),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
