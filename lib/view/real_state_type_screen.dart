import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/RealStateTypeController.dart';
import 'package:rentmaster/model/sqldb.dart';


class RealStateTypeScreen extends StatefulWidget {
  const RealStateTypeScreen({super.key});

  @override
  State<RealStateTypeScreen> createState() => _RealStateTypeScreenState();
}

class _RealStateTypeScreenState extends State<RealStateTypeScreen> {
   Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController namecontroller = TextEditingController();

  final Realstatetypecontroller realstatetypecontroller = Get.put(Realstatetypecontroller());
  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text("إنشاء نوع للعقارات"),
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
                  // RealStatename Field
                  TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: 'إسم النوع',
                      hintText: 'أكتب نوع العقار',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء كتابة نوع العقار';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          // Check if RealStateType already exists
                          List<Map> existingRealStateType = await sqldb.selectRaw(
                              'SELECT * FROM "real_state_type" WHERE name = "${namecontroller.text}"');

                          if (existingRealStateType.isNotEmpty) {
                            Get.snackbar(
                              'خطأ',
                              'إسم مجموعة العقار غير متاح',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            // Insert new user data
                            int response = await sqldb.insert('real_state_type', {
                              'name': namecontroller.text,
                              'create_date': DateTime.now().toString(),
                            });

                            if (response > 0) {
                              Get.snackbar(
                              'تم',
                              'إدراج مجموعة العقار ',
                              backgroundColor: const Color.fromARGB(255, 0, 156, 29),
                              colorText: Colors.white,
                            );
                            namecontroller.clear();
                              
                            }
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
                        'إدراج مجموعة العقار',
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
