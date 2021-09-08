import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps/screens/choose_language.dart';
import 'package:maps/screens/maps/map_screen.dart';
import 'logics/ob_server.dart';

Widget? initialPage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  FirebaseAuth.instance.authStateChanges().listen((event) {
    if (event == null)
      initialPage = ChooseLanguage();
    else
      initialPage = MapScreen();
  });
  Bloc.observer = MyBlocObserver();
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: Locale('en'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: initialPage,
    );
  }
}
