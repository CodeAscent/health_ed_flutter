import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_state.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/modules/home/repository/home_repository.dart';
import 'package:health_ed_flutter/modules/home/widgets/QuizItem.dart';
import 'package:health_ed_flutter/modules/navigation/views/screens/MainScreen.dart';

class AllQuizzesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepository())..add(GetAllDayRequested()),
      child: AllQuizzesContent(),
    );
  }
}

class AllQuizzesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop == false) {
          Get.offAll(MainScreen());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bg/auth_bg.png'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTransparentContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppBackButton(
                                onTap: () {
                                  Get.offAll(MainScreen());
                                },
                              ),
                              SizedBox(width: 8),
                              Text(
                                'All Quizzes',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final screenWidth = constraints.maxWidth;
                                int crossAxisCount = 2;
                                if (screenWidth > 600) {
                                  crossAxisCount = 3;
                                }
                                if (screenWidth > 900) {
                                  crossAxisCount = 4;
                                }

                                return BlocBuilder<HomeBloc, HomeState>(
                                  builder: (context, state) {
                                    if (state is AllDaysLoading) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (state is GetAllDaySuccess) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: GridView.builder(
                                          padding: EdgeInsets.only(top: 10),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            childAspectRatio: 1 / 0.7,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 20,
                                          ),
                                          itemCount: state.getAllDaysResponse
                                              .data!.days!.length,
                                          itemBuilder: (context, index) {
                                            final dayData = state
                                                .getAllDaysResponse
                                                .data!
                                                .days![index];
                                            return QuizItem(
                                              dayIndex: index,
                                              prevDayProgress: index > 0
                                                  ? state
                                                      .getAllDaysResponse
                                                      .data!
                                                      .days![index - 1]
                                                      .progress!
                                                      .toDouble()
                                                  : 100.0,
                                              dayId: dayData.sId!,
                                              day: 'Day ${dayData.dayNumber}',
                                              progress:
                                                  dayData.progress!.toDouble(),
                                              isLocked: dayData.locked!,
                                              canOpen: dayData.canOpen ?? false,
                                              mContext: context,
                                            );
                                          },
                                        ),
                                      );
                                    } else if (state is GetAllDayFailure) {
                                      return Center(child: Text(state.message));
                                    }
                                    return CustomLoader();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
