
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/vocabulary_model.dart';
import 'Provider/timer_provider.dart';
import 'Provider/vocabulary_provider.dart';
import 'Utils/Network/http.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  VocabularyModel model = VocabularyModel();cd
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider<VocabularyProvider>(
          create: (context) => VocabularyProvider(model, context),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dar Patente',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
