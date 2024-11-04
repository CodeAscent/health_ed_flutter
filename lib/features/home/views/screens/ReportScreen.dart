import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';
import 'dart:math' as math;

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
                                _buildWeeklyReport(state,context),
                                SizedBox(height: 20),
                                _buildCategoryChart(),
                                SizedBox(height: 20),
                                _categoryBarChart(),
                                SizedBox(height: 20),
                                _buildCategoryChart(),
                                SizedBox(height: 20),
                                _barChart() ,
                                SizedBox(height: 20),

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
    return
      Container(
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

  Widget _buildCategoryChart() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Recent Quizzes",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Spacer(),
              // Card with an icon in the center
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2),
                  ],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Padding inside the card
                  child: Icon(
                    Icons.table_rows_outlined,
                    size: 14,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                padding: EdgeInsets.all(8),
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2),
                  ],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center align the row content
                  children: [
                    Text(
                      "Week Wise",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    SizedBox(width: 4), // Optional: Add some space between text and icon
                    Icon(Icons.keyboard_arrow_down_rounded), // Dropdown icon
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // Space between the rows
          // Card with "Week Wise" and dropdown icon
        ],
      ),
    );
  }

  Widget _buildWeeklyReport(DashboardLoaded state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start
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
                      text: "30 mins",
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
              _buildReportTable(state),
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
              gradient: _activeDayIndex == index ?  ColorPallete.gradient:null,
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

  Widget _buildReportTable(DashboardLoaded state) {
    return Table(
      border: TableBorder(
        top: BorderSide(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid, width: 1),
        horizontalInside: BorderSide(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid, width: 1), // Lines between rows
        verticalInside: BorderSide(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid, width: 1),   // Middle column line
      ),
      children: [
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Activities', style: TextStyle(fontSize: 14.0))
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Status', style: TextStyle(fontSize: 13.0))
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Screen time', style: TextStyle(fontSize: 14.0))
          )]),
        ]),
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('1')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Completed')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('10 mins')
          )]),
        ]),
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('2')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Completed')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('10 mins')
          )]),
        ]),
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('3')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Completed')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('---')
          )]),
        ]),
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('4')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Incomplete')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('10 mins')
          )]),
        ]),
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('5')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Incomplete')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('10 mins')
          )]),
        ]),
        TableRow(children: [
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('6')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Incomplete')
          )]),
          Column(children: [Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('10 mins')
          )]),
        ]),
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
                  return
                    Container(

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30,),
                            Transform.rotate(
                              angle: -math.pi / 2, // Rotate text -90 degrees
                              child: Text(
                                _getDayName(value.toInt()), // Get the day name
                                style: TextStyle(fontSize: 12), // Adjust font size if needed
                                textAlign: TextAlign.center, // Center align text
                              ),
                            ),
                          ],
                        )
                    );
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
                  return
                    Container(

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30,),
                            Transform.rotate(
                              angle: -math.pi / 2, // Rotate text -90 degrees
                              child: Text(
                                _getDayName(value.toInt()), // Get the day name
                                style: TextStyle(fontSize: 12), // Adjust font size if needed
                                textAlign: TextAlign.center, // Center align text
                              ),
                            ),
                          ],
                        )
                    );
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

}
