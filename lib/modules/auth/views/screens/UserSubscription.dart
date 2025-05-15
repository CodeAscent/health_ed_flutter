import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResUserPlanData.dart';
import 'package:health_ed_flutter/modules/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/AllPlanScreen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/InvoiceViewerPage.dart';

class UserSubscription extends StatelessWidget {
  const UserSubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository())..add(UserPlanDataRequested()),
      child: const UserSubscriptionContent(),
    );
  }
}

class UserSubscriptionContent extends StatefulWidget {
  const UserSubscriptionContent({Key? key}) : super(key: key);

  @override
  State<UserSubscriptionContent> createState() =>
      UserSubscriptionContentScreen();
}

class UserSubscriptionContentScreen extends State<UserSubscriptionContent> {
  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final DateTime parsedDate = DateTime.parse(isoDate);
    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
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
                      const SizedBox(height: 10),
                      Expanded(
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is UserPlanDataSuccess) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AppBackButton(),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            'Subscription Details',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _buildPlanCard(state.resUserPlanData.data),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    InvoiceViewerPage(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.download,
                                              color: Colors.white),
                                          label: const Text("Download",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Get.to(() => AllPlanScreen());
                                          },
                                          icon: const Icon(Icons.upgrade,
                                              color: Colors.white),
                                          label: const Text("Upgrade Premium",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              );
                            } else if (state is UserPlanDataFailure) {
                              return Center(child: Text(state.message));
                            }
                            return const CustomLoader();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(Data? data) {
    final bool isActive = data?.status?.toLowerCase() == "active";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Name & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  data!.plan!.name!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                '₹${data.plan!.price}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status
          Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.cancel,
                color: isActive ? Colors.green : Colors.red,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Dates
          Row(
            children: [
              const Icon(Icons.date_range, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                'Start: ${_formatDate(data.startDate)}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                'Expires: ${_formatDate(data.endDate)}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Duration Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.plan!.duration!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            data.plan!.description!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Features',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Features List
          ...data.plan!.features!.map<Widget>((feature) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 18, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
