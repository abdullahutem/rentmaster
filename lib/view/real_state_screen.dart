import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/currencey_controller.dart';
import 'package:rentmaster/controller/owners_controller.dart';
import 'package:rentmaster/controller/real_state_controller.dart';
import 'package:rentmaster/controller/real_state_type_controller.dart';
import 'package:rentmaster/controller/tenants_controller.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/model/owners_model.dart';
import 'package:rentmaster/model/real_state_model.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:rentmaster/model/tenants_model.dart';

class RealStateScreen extends StatefulWidget {
  const RealStateScreen({super.key});

  @override
  State<RealStateScreen> createState() => _RealStateScreenState();
}

class _RealStateScreenState extends State<RealStateScreen> {
  final Realstatetypecontroller realstatetypecontroller =
      Get.put(Realstatetypecontroller());
  final OwnersController ownersController = Get.put(OwnersController());
  RxString selectedItem = ''.obs;
  RxString selectedCurrencey = ''.obs;
  RxString selectedOwner = ''.obs;
  RxString selectedTenant = ''.obs;
  RxString selectedRealStateParent = ''.obs;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  RxBool isrentable = true.obs;
  GlobalKey<FormState> formstate = GlobalKey();
  Sqldb sqldb = Sqldb();
  RxInt is_rentable =
      0.obs; //معنى انه العقار يما يتاجز بنفسه هناك ابناء له هذا في حالة ان القيمة تساوي واحد
  final UserController userController = Get.put(UserController());
  final CurrenceyController currenceyController = CurrenceyController();
  var ownersList = <OwnersModel>[].obs;
  var tenants_List = <TenantsModel>[].obs;
  var real_stateList = <RealStateModel>[].obs;
  final TenantsController tenantsController = TenantsController();
  final RealStateController realStateController = RealStateController();

// Fetch owners and update the list
  Future<void> getOwners() async {
    await ownersController
        .fetchOwnersBasedOnCreatedBy(userController.currentUser.value.username);
    ownersList.assignAll(ownersController.ownersList);
  }

  Future<void> getTenants() async {
    await tenantsController.fetchTenantsBasedOnCreatedBy(
        userController.currentUser.value.username);
    tenants_List.assignAll(tenantsController.tenantsList);
  }

  Future<void> getrealStateParents() async {
    await realStateController.fetchRealStateParentsBasedOnCreatedBy(
        userController.currentUser.value.username);
    real_stateList.assignAll(realStateController.realStateList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currenceyController.fetchCurrencyList();
    getOwners();
    getTenants();
    getrealStateParents();
  }

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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
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
                            value: selectedItem.value.isEmpty
                                ? null
                                : selectedItem.value,
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
                                is_rentable.value = 0;
                              } else {
                                is_rentable.value = 1;
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
                    const Text(
                      "إختر المالك :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
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
                            hint: const Text('المالك'),
                            value: selectedOwner.value.isEmpty
                                ? null
                                : selectedOwner.value,
                            items: ownersList.map((type) {
                              return DropdownMenuItem<String>(
                                value: type.name,
                                child: Text(type.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                selectedOwner.value = value;
                              }
                            },
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    const Text(
                      "إختر الأصل :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return AbsorbPointer(
                        absorbing: !isrentable.value,
                        child: Container(
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
                              hint: const Text('الأصل'),
                              value: selectedRealStateParent.value.isEmpty
                                  ? null
                                  : selectedRealStateParent.value,
                              items: real_stateList.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type.name,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedRealStateParent.value = value;
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    const Text(
                      "إختر المستأجر :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return AbsorbPointer(
                        absorbing: !isrentable.value,
                        child: Container(
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
                              hint: const Text('المستأجر'),
                              value: selectedTenant.value.isEmpty
                                  ? null
                                  : selectedTenant.value,
                              items: tenants_List.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type.name,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedTenant.value = value;
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      "إختر العملة :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (currenceyController.currencyList.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return AbsorbPointer(
                        absorbing: !isrentable.value,
                        child: Container(
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
                              hint: const Text('العملة'),
                              value: selectedCurrencey.value.isEmpty
                                  ? null
                                  : selectedCurrencey.value,
                              items:
                                  currenceyController.currencyList.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type.name,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedCurrencey.value = value;
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    AbsorbPointer(
                      absorbing: !isrentable.value,
                      child: TextFormField(
                        controller: pricecontroller,
                        decoration: InputDecoration(
                          labelText: 'سعر العقار',
                          hintText: 'أكتب سعر العقار',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.attach_money_outlined,
                            color: MyColors.myYellow,
                          ),
                        ),
                      ),
                    ),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            int typeid = await realstatetypecontroller
                                .getRealStateTypeId(selectedItem.value);
                   
                                print('=================$typeid');
                            int currency_id = await currenceyController
                                .getCurrencyId(selectedCurrencey.value);
                            int response = await sqldb.insert('real_state', {
                              'name': namecontroller.text,
                              'type_id': typeid,
                              'is_rentable': is_rentable.value,
                              //'rentStatus': 1,
                              'parent_id': 1,
                              'price': pricecontroller.text,
                              'currency_id': currency_id,
                              'description': descriptioncontroller.text,
                              'created_by':
                                  userController.currentUser.value.username,
                              'create_date': DateTime.now().toString(),
                            });
                            if (response > 0) {
                              Get.snackbar(
                                'تم',
                                'إدراج العقار ',
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 156, 29),
                                colorText: Colors.white,
                              );
                              namecontroller.clear();
                            } else {
                              Get.snackbar(
                                'فشل',
                                'إدراج العقار ',
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
