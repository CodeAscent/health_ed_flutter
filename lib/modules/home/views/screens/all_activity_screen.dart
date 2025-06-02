import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_state.dart';
import 'package:health_ed_flutter/modules/home/widgets/ActivityCardItem.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../activity/views/activity_Instructions_screen.dart';

class AllActivityScreen extends StatelessWidget {
  final String activityId;
  final String dayName;

  const AllActivityScreen({
    Key? key,
    required this.activityId,
    required this.dayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AllActivityContent(activityId: activityId, dayName: dayName);
  }
}

class AllActivityContent extends StatefulWidget {
  final String activityId;
  final String dayName;

  const AllActivityContent({
    Key? key,
    required this.activityId,
    required this.dayName,
  }) : super(key: key);

  @override
  State<AllActivityContent> createState() => _AllActivityContentState();
}

class _AllActivityContentState extends State<AllActivityContent> {
  @override
  void initState() {
    super.initState();
    context
        .read<HomeBloc>()
        .add(GetAllActivityRequested(activityId: widget.activityId));
  }

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
                            widget.dayName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is AllActivityLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is GetAllActivitySuccess) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 8),
                              itemCount:
                                  state.resAllActivity.data!.activities!.length,
                              itemBuilder: (context, index) {
                                final activity = state
                                    .resAllActivity.data!.activities![index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => ActivityInstructionsScreen(
                                          activityId: activity.sId!,
                                        ))?.then((_) {
                                      context.read<HomeBloc>().add(
                                          GetAllActivityRequested(
                                              activityId: widget.activityId));
                                      setState(() {});
                                    });
                                  },
                                  child: ActivityCardItem(activity: activity),
                                );
                              },
                            );
                          } else if (state is GetAllActivityFailure) {
                            return Center(child: Text(state.message));
                          }
                          return CustomLoader();
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
