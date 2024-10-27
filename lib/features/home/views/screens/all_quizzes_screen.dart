import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';

import '../../bloc/QuizBloc.dart';
import '../../bloc/QuizState.dart';
import '../../widget/QuizItem.dart';

class AllQuizzesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                CustomTransparentContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppBackButton(),
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
                      BlocBuilder<QuizBloc, QuizState>(
                        builder: (context, state) {
                          if (state is QuizLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is QuizLoaded) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1 / 0.7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 30,
                                ),
                                itemCount: state.quizLockStates.length,
                                itemBuilder: (context, index) {
                                  return QuizItem(
                                    day: 'Day ${index + 1}',
                                    completed: false,
                                    isLocked: state.quizLockStates[index],
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(child: Text('Something went wrong'));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}