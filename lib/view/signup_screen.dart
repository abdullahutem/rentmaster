import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:get/get.dart';
import 'package:rentmaster/view/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController repeatpasswordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text("إنشاء حساب"),
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
                  // name Field
                  TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: 'الإسم',
                      hintText: 'أكتب الإسم ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء كتابة الإسم ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
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

                  // Email Field
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتزوني',
                      hintText: 'أكتب البريد الإلكتروني',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء كتابة البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Phone Number Field
                  Directionality(
                    textDirection:
                        TextDirection.ltr, // Force LTR for phone field
                    child: IntlPhoneField(
                      controller: phonenumbercontroller,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        hintText: 'أكتب رقم الهاتف',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'YE', // Yemen as default country
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
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
                  SizedBox(height: 20),

                  // Confirm Password Field
                  TextFormField(
                    controller: repeatpasswordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'تاكيد كلمة المرور',
                      hintText: 'الرجاء تاكيد كلمة المرور',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء تاكيد كلمة المرور';
                      }
                      if (value != passwordcontroller.text) {
                        return 'كلمة المرور غير متطابقين';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          // Check if username already exists
                          List<Map> existingUser = await sqldb.selectRaw(
                              'SELECT * FROM "users" WHERE user_name = "${usernamecontroller.text}"');

                          if (existingUser.isNotEmpty) {
                            Get.snackbar(
                              'خطأ',
                              'إسم المستخدم غير متاح',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            // Insert new user data
                            int response = await sqldb.insert('users', {
                              'name': namecontroller.text,
                              'user_name': usernamecontroller.text,
                              'email': emailcontroller.text,
                              'phone_number': phonenumbercontroller.text,
                              'password': passwordcontroller.text,
                              'created_by': usernamecontroller.text,
                              'create_date': DateTime.now().toString(),
                            });

                            if (response > 0) {
                              Get.to(LoginScreen());
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: MyColors.myYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'إضافة مستخدم',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
