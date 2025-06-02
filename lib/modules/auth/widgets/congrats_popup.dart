import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/modules/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/modules/navigation/views/screens/MainScreen.dart';

class CongratsPopup extends StatelessWidget {
  final String level;
  final String complaint;
  final String provisionalDiagnosis;
  final String sensoryIssue;
  final String speechDevelopment;
  final String generalBehaviour;
  final String cognitiveSkills;
  final String socialBehaviour;

  const CongratsPopup({
    Key? key,
    required this.level,
    required this.complaint,
    required this.provisionalDiagnosis,
    required this.sensoryIssue,
    required this.speechDevelopment,
    required this.generalBehaviour,
    required this.cognitiveSkills,
    required this.socialBehaviour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Stack(
          children: [
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/images/menrunning.png',
                          width: 100, height: 100),
                      const SizedBox(height: 10),
                      // const Text(
                      //   'Congratulations!',
                      //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      //   textAlign: TextAlign.center,
                      // ),
                      const SizedBox(height: 10),
                      Text(
                        '$level',
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow('Complaint', complaint),
                      _buildInfoRow(
                          'Provisional Diagnosis', provisionalDiagnosis),
                      _buildInfoRow('Sensory Issue', sensoryIssue),
                      const Divider(height: 30),
                      const Text(
                        'Parameters & Status',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow('Speech Development', speechDevelopment),
                      _buildInfoRow('General Behaviour', generalBehaviour),
                      _buildInfoRow('Cognitive Skills', cognitiveSkills),
                      _buildInfoRow('Social Behaviour', socialBehaviour),
                      Text(
                        'Report can be downloaded in Profile section',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/confetti.gif',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  _navigateToNextScreen();
                },
              ),
            ),
          ],
        ));
  }

  void _navigateToNextScreen() async {
    await AuthRepository().fetchUser();
    Get.back();
    Get.to(MainScreen());
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$title:',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w400),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
