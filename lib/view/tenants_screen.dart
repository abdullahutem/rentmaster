import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/tenants_controller.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:get/get.dart';
import 'package:rentmaster/model/tenants_model.dart';


class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TenantsController tenantsController = Get.put(TenantsController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController newnameController = TextEditingController();
    final GlobalKey<FormState> formState = GlobalKey<FormState>();
    final UserController userController = Get.put(UserController());
    String tenantOldName;
    Sqldb sqldb = Sqldb();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text(
          "المستاجرين",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form to add a new tenant
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'إسم المستاجر',
                      hintText: 'أكتب إسم المستاجر',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال إسم المستاجر';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Phone Number Field
                  IntlPhoneField(
                    controller: phoneController,
                    decoration: const InputDecoration(
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

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          List<Map> existingTenantName = await sqldb.selectRaw(
                              'SELECT * FROM "tenants" WHERE name = "${nameController.text}" AND created_by = "${userController.currentUser.value.username}"');
                          if (existingTenantName.isNotEmpty) {
                            Get.snackbar(
                              'خطأ',
                              'إسم المستاجر موجود مسبقا',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());

                            // Create a new tenant
                            await tenantsController.createNewTenants(
                              nameController.text,
                              phoneController.text,
                              "${userController.currentUser.value.username}",
                              formattedDate,
                            );
                            // Refresh the list of tenants
                            await tenantsController
                                .fetchTenantsBasedOnCreatedBy(
                                    userController.currentUser.value.username);
                            nameController.clear();
                            phoneController.clear();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إدراج إسم المستاجر',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display the list of Tenants
            FutureBuilder(
                future: tenantsController.fetchTenantsBasedOnCreatedBy(
                    userController.currentUser.value.username),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  }
                  return Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: tenantsController.tenantsList.length,
                        itemBuilder: (context, index) {
                          final TenantsModel tenant =
                              tenantsController.tenantsList[index];
                          return Card(
                            child: ListTile(
                              title: Text(tenant.name),
                              subtitle:
                                  Text('رقم الجوال : ${tenant.phone_number}'),
                              leading: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  // Fetch the tenant's current name
                                  tenantOldName = await tenantsController
                                      .getTenantsName(tenant.id);
                                  newnameController.text = tenantOldName;

                                  final GlobalKey<FormState> dialogFormKey =
                                      GlobalKey<FormState>();

                                  // Show dialog for editing
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.info,
                                    body: Form(
                                      key: dialogFormKey,
                                      child: Column(
                                        children: [
                                          const Text(
                                            'تعديل إسم المستاجر',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            controller: newnameController,
                                            decoration: const InputDecoration(
                                              labelText: 'إسم المستاجر',
                                              hintText:
                                                  'أكتب إسم المستاجر الجديد',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء إدخال إسم المستاجر';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    btnOkOnPress: () async {
                                      if (dialogFormKey.currentState!
                                          .validate()) {
                                        List<Map> existingTenantName =
                                            await sqldb.selectRaw(
                                                'SELECT * FROM "tenants" WHERE name = "${newnameController.text}" AND created_by = "${userController.currentUser.value.username}"');
                                        if (existingTenantName.isNotEmpty) {
                                          Get.snackbar(
                                            'خطأ',
                                            'إسم المستاجر موجود مسبقا',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        } else {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(DateTime.now());
                                          // Update tenant name
                                          await tenantsController
                                              .updateTenantsNameUseingId(
                                            tenant.id,
                                            tenantOldName,
                                            newnameController.text,
                                            userController
                                                .currentUser.value.username,
                                            formattedDate,
                                          );
                                          // Refresh the list
                                          await tenantsController
                                              .fetchTenantsBasedOnCreatedBy(
                                            userController
                                                .currentUser.value.username,
                                          );
                                          newnameController.clear();
                                        }
                                      } else {
                                        // If validation fails, prevent dialog from closing
                                        return;
                                      }
                                    },
                                  ).show();
                                },
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await tenantsController.sqldb.delete(
                                    'tenants',
                                    'id = "${tenant.id}"',
                                  );
                                  // Refresh the list of tenants
                                  await tenantsController
                                      .fetchTenantsBasedOnCreatedBy(
                                          userController
                                              .currentUser.value.username);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
