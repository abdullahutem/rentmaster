import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/view/owners_screen.dart';
import 'package:rentmaster/view/profile_screen.dart';
import 'package:rentmaster/view/real_state_screen.dart';
import 'package:rentmaster/view/real_state_type_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  //final Userslogin userslogin = Get.find<Userslogin>();
  final UserController userController = Get.put(UserController());
  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            "Welcome, ${userController.currentUser.value.username}")), // Display username in AppBar
        backgroundColor: MyColors.myYellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 columns for dashboard cards
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // Dashboard Cards
            _buildDashboardCard(
              icon: Icons.person,
              title: 'الملف الشخصي',
              color: Colors.blue,
              onTap: () {
                // Navigate to profile screen
                Get.to(ProfileScreen());
                // print('=======================${userslogin.username}');
              },
            ),
            _buildDashboardCard(
              icon: Icons.home_work_outlined,
              title: 'إضافة اصول',
              color: Colors.green,
              onTap: () {
                // Navigate to orders screen
                Get.to(RealStateTypeScreen());
              },
            ),
            _buildDashboardCard(
                icon: Icons.home,
                title: 'إضافة عقارات',
                color: Colors.pink,
                onTap: () {
                  Get.to(RealStateScreen());
                }),
            _buildDashboardCard(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              color: Colors.red,
              onTap: () {
                //userslogin.logout();
                Get.offAllNamed('welcomescreen');
              },
            ),
            _buildDashboardCard(
                icon: Icons.precision_manufacturing_rounded,
                title: 'إدارة الملاك',
                color: Colors.amberAccent,
                onTap: (){
                 Get.to(OwnersScreen());

                }),
          ],
        ),
      ),
    );
  }

  // Helper method to build each dashboard card
  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        color: color.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
