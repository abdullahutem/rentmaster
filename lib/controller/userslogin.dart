import 'package:get/get.dart';

class Userslogin extends GetxController {
  // Observable variables
  var isLoggedIn = false.obs;   // To track login state
  var username = ''.obs;        // To store the username

  // Login function
  void login(String user) {
    username.value = user;
    isLoggedIn.value = true;     // Set user as logged in
  }

  // Logout function
  void logout() {
    username.value = '';
    isLoggedIn.value = false;    // Set user as logged out
  }
}
