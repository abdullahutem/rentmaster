import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/real_state_type_controller.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/model/sqldb.dart';

class RealStateScreen extends StatefulWidget {
  const RealStateScreen({super.key});

  @override
  State<RealStateScreen> createState() => _RealStateScreenState();
}

class _RealStateScreenState extends State<RealStateScreen> {
  final Realstatetypecontroller realstatetypecontroller =
      Get.put(Realstatetypecontroller());
  RxString selectedItem = "عمارة".obs;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  RxBool isrentable = false.obs;
  GlobalKey<FormState> formstate = GlobalKey();
  Sqldb sqldb = Sqldb();
  int is_rentable =
      1; //معنى انه العقار يما يتاجز بنفسه هناك ابناء له هذا في حالة ان القيمة تساوي واحد
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text(
          "إنشاء نوع للعقارات",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: realstatetypecontroller.fetchRealStateTypeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        labelText: 'إسم العقار',
                        hintText: 'أكتب إسم العقار',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(
                          Icons.home,
                          color: MyColors.myYellow,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء كتابة اسم العقار';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "إختر نوع العقار :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (realstatetypecontroller.realStateTypeList.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: MyColors.myYellow, width: 1),
                          color: Colors.amber[50],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            iconEnabledColor: MyColors.myYellow,
                            iconSize: 32,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            hint: const Text('إختر نوع العقار'),
                            value: selectedItem.value,
                            items: realstatetypecontroller.realStateTypeList
                                .map((type) {
                              return DropdownMenuItem<String>(
                                value: type.name,
                                child: Text(type.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                selectedItem.value = value;
                              }
                            },
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Obx(() {
                      return Material(
                        elevation: 2, // Adds a subtle shadow effect
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 243,
                                243), // Lighter background color for contrast
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CheckboxListTile(
                            value: isrentable.value,
                            onChanged: (bool? newvalue) {
                              isrentable.value = newvalue!;
                              if (isrentable == true) {
                                is_rentable = 0;
                              } else {
                                is_rentable = 1;
                              }
                            },
                            activeColor: Colors.amberAccent,
                            checkColor: Colors.white,
                            title: Text(
                              'قابلة للإيجار',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight
                                    .w600, // Increased for a bolder look
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'تحديد اذا كان هذا القعقار يتم تاجيره بنفسه او يكون تحته عدة عقارات',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: descriptioncontroller,
                      decoration: InputDecoration(
                        labelText: 'وصف العقار',
                        hintText: 'أكتب وصف العقار',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                          color: MyColors.myYellow,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          int typeid = await realstatetypecontroller
                              .getRealStateTypeId(selectedItem.value);
                          int response = await sqldb.insert('real_state', {
                            'name': namecontroller.text,
                            'type_id': typeid,
                            'is_rentable': is_rentable,
                            'description': descriptioncontroller.text,
                            'created_by':
                                userController.currentUser.value.username,
                            'create_date': DateTime.now().toString(),
                          });
                          if (response > 0) {
                            Get.snackbar(
                              'تم',
                              'إدراج مجموعة العقار ',
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 156, 29),
                              colorText: Colors.white,
                            );
                            namecontroller.clear();
                          }else{
                            Get.snackbar(
                              'تم',
                              'إدراج مجموعة العقار ',
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 0, 0),
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.myYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}