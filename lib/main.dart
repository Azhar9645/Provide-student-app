import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students_app_provider/provider/add_student.dart';
import 'package:students_app_provider/provider/edit_student_p.dart';
import 'package:students_app_provider/provider/splash_p.dart';
import 'package:students_app_provider/provider/student_details_p.dart';
import 'package:students_app_provider/provider/student_list_p.dart';
import 'package:students_app_provider/screens/widgets/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AddStudentProvider()),
        ChangeNotifierProvider(create: (_) => StudentListProvider()),
        ChangeNotifierProvider(create: (_) => EditStudentProvider()),
        ChangeNotifierProvider(create: (_) => StudentDetailProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Provider App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        
      ),
    );
  }
}
