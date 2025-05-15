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
              padding: const EdgeInsets.all(8.0),
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
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                if (state is AllDaysLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (state is GetAllDaySuccess) {
                                  return Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: SingleChildScrollView(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1 / 0.7,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 30,
                                        ),
                                        itemCount: state.getAllDaysResponse
                                            .data!.days!.length,
                                        itemBuilder: (context, index) {
                                          return QuizItem(
                                            dayId: state.getAllDaysResponse
                                                .data!.days![index].sId!,
                                            day:
                                                'Day ${state.getAllDaysResponse.data!.days![index].dayNumber}',
                                            progress: state.getAllDaysResponse
                                                .data!.days![index].progress!
                                                .toDouble(),
                                            isLocked: state.getAllDaysResponse
                                                .data!.days![index].locked!,
                                            mContext: context,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else if (state is GetAllDayFailure) {
                                  return Center(child: Text(state.message));
                                }
                                return CustomLoader();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
