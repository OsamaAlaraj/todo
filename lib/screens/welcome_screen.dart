import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController namecontroller = TextEditingController();

  @override
  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tudee',
          style: TextStyle(
            fontFamily: 'CherryBomb',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF08083B),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
          color: Color(0xFFF0F4F8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's get started",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Color(0xFF08083B)),
            ),
            SizedBox(height: 10),
            Text(
              "What should we call you?",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(
                hintText: 'Your name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('name', namecontroller.text);
                // التحقق من أن الشاشة لا تزال موجودة قبل استخدام context
                if (!context.mounted) return;
                Navigator.pushNamed(context, '/home',arguments: {
                  'user_name':namecontroller.text
                });
              },
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF08083B),
                ),
                child: Center(child: Text('Save',style: TextStyle(color: Color(0xFFF0F4F8)),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
