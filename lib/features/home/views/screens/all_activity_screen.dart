import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/features/activity/views/MatchScreen.dart';
import 'package:health_ed_flutter/features/activity/views/PictureDescriptionScreen.dart';
import 'package:health_ed_flutter/features/activity/views/VideoDescriptionScreen.dart';
import 'package:health_ed_flutter/features/home/model/Activity.dart';
import 'package:health_ed_flutter/features/home/views/screens/activity_Instructions_screen.dart';

import '../../bloc/ActivityBlock.dart';
import '../../bloc/QuizBloc.dart';
import '../../bloc/QuizState.dart';
import '../../widgets/ActivityCardItem.dart';

class AllActivityScreen extends StatelessWidget {
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
                            'Day1',
                              style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      BlocBuilder<ActivityCubit, List<Activity>>(
                        builder: (context, activities) {
                          return Expanded( // Wrap with Expanded to resolve the issue
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                              itemCount: activities.length,
                              itemBuilder: (context, index) {
                                final activity = activities[index];
                                return GestureDetector(
                                  onTap:(){
                                    if(index==0)
                                      {
                                        Get.to(()=>ActivityInstructionsScreen());
                                      }else if(index==1)
                                      {
                                        Get.to(MatchScreen());
                                      }else if(index==2)
                                      {
                                        Get.to(PictureDescriptionScreen());
                                      }else if(index==3)
                                      {
                                        Get.to(VideoDescriptionScreen());
                                      }
                                  },
                                  child:ActivityCardItem(activity: activity),
                                );

                              },
                            ),
                          );
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
