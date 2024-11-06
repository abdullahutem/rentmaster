import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:rentmaster/view/signup_screen.dart';
import 'package:rentmaster/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final UserController userController = Get.put(UserController());

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("تسجيل الدخول"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username Field
                  TextFormField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      labelText: 'إسم المستخدم',
                      hintText: 'أكتب إسم المستخدم',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء كتابة اسم المستخدم';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      hintText: 'أكتب كلمة المرور',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء كتابة كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          bool loginSuccess = await userController.checkLogin(
                            usernamecontroller.text,
                            passwordcontroller.text,
                          );
                          if (loginSuccess) {
                            Get.snackbar(
                              'نجاح',
                              'تم تسجيل الدخول بنجاح',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            userController.currentUser.update((user) {
                              if (user != null) {
                                user.username = usernamecontroller.text;
                              }
                            });
                            // Redirect user to home page or dashboard
                            Get.to(HomeScreen(
                              username: usernamecontroller.text,
                            ));
                          } else {
                            Get.snackbar(
                              'خطأ',
                              'إسم المستخدم أو كلمة المرور غير صحيحة',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Signup Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟'),
                      TextButton(
                        onPressed: () {
                          Get.to(SignupScreen());
                        },
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
