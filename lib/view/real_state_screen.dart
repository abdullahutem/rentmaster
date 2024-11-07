import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/real_state_type_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text("إنشاء نوع للعقارات"),
      ),
      body: FutureBuilder(
          future: realstatetypecontroller.fetchRealStateTypeList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading user data'));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        labelText: 'إسم العقار',
                        hintText: 'أكتب إسم العقار',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء كتابة اسم العقار';
                        }
                        return null;
                      },
                    ),
                    Text(
                      " إختر نوع العقار :  ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      // Check if the list is populated
                      if (realstatetypecontroller.realStateTypeList.isEmpty) {
                        return CircularProgressIndicator();
                      }
                      return DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.amber,
                        iconEnabledColor: Colors.amber,
                        iconSize: 38,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        hint: Text('إختر نوع العقار'),
                        value: selectedItem.value,
                        items: realstatetypecontroller.realStateTypeList
                            .map((type) {
                          return DropdownMenuItem<String>(
                            value: type.name,
                            child: Text(type.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedItem.value = value ?? " ";
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
