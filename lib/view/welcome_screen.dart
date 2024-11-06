import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:rentmaster/view/login_screen.dart';
import 'package:rentmaster/view/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Sqldb sqldb = Sqldb();
    return Scaffold(
      body: Stack(
        children: [
          // Background Image or Color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [MyColors.myYellow, Colors.orange.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Welcome Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Logo or Icon
                  Icon(
                    Icons.home_work_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),

                  // Welcome Text
                  Text(
                    'مرحبا بك في ماستر لإدادة العقارات',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),

                  // Sub-Text
                  Text(
                    'إدارة ممتلكاتك بكل سهولة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 60),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'تسجيل دخول',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Signup Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.to(SignupScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  MaterialButton(onPressed: (){
                    sqldb.deleteMyDatabase();
                  },child: Text('Delete'),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
