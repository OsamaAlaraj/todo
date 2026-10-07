import 'package:todo/database/database.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/manage_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // لازم وجوده عند استخدام مكتبات التخزين سواء محلي او اونلاين
  await HiveService().init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedName = prefs.getString('name') ?? '';
  runApp(MyApp(name: savedName,));
}

class MyApp extends StatelessWidget {
  final String name;
  const MyApp({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: name.isEmpty ?'/welcome':'/home',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(name: name),
        '/add_task': (context) => ManageTask(title: '', titleButton: '', hintText: '',),
      },
    );
  }
}
