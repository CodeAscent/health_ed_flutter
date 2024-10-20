import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/theme/app_theme.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/features/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/features/auth/views/screens/login_screen.dart';
import 'package:health_ed_flutter/features/auth/views/screens/signup_screen.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(AuthRepository()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: AppTheme.lightTheme(),
        title: 'Health Ed Tech',
        home: FutureBuilder(
          future: LocalStorage.getString('token'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LoginScreen();
            }
            return SignupScreen();
          },
        ),
      ),
    );
  }
}
