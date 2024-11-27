import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentmaster/constans/my_colors.dart';
import 'package:rentmaster/controller/owners_controller.dart';
import 'package:rentmaster/controller/user_controller.dart';
import 'package:rentmaster/model/owners_model.dart';
import 'package:rentmaster/model/sqldb.dart';

class OwnersScreen extends StatelessWidget {
  const OwnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OwnersController ownersController = Get.put(OwnersController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController newnameController = TextEditingController();
    final GlobalKey<FormState> formState = GlobalKey<FormState>();
    final UserController userController = Get.put(UserController());
    String ownerOldName;
    Sqldb sqldb = Sqldb();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text(
          "ملاك العقارات",
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
            // Form to add a new owner
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'إسم المالك',
                      hintText: 'أكتب إسم المالك',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال إسم المالك';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          List<Map> existingOwnerName = await sqldb.selectRaw(
                              'SELECT * FROM "owners" WHERE name = "${nameController.text}" AND created_by = "${userController.currentUser.value.username}"');
                          if (existingOwnerName.isNotEmpty) {
                            Get.snackbar(
                              'خطأ',
                              'إسم المالك موجود مسبقا',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());

                            // Create a new owner
                            await ownersController.createNewOwners(
                              nameController.text,
                              "${userController.currentUser.value.username}",
                              formattedDate,
                            );
                            // Refresh the list of owners
                            await ownersController.fetchOwnersBasedOnCreatedBy(
                                userController.currentUser.value.username);
                            nameController.clear();
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
                        'إدراج إسم المالك',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display the list of owners
            FutureBuilder(
                future: ownersController.fetchOwnersBasedOnCreatedBy(
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
                        itemCount: ownersController.ownersList.length,
                        itemBuilder: (context, index) {
                          final OwnersModel owner =
                              ownersController.ownersList[index];
                          return Card(
                            child: ListTile(
                              title: Text(owner.name),
                              subtitle:
                                  Text('تاريخ الإضافة: ${owner.createdate}'),
                              leading: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  // Fetch the owner's current name
                                  ownerOldName = await ownersController
                                      .getOwnerName(owner.id);
                                  newnameController.text = ownerOldName;

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
                                            'تعديل إسم المالك',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            controller: newnameController,
                                            decoration: const InputDecoration(
                                              labelText: 'إسم المالك',
                                              hintText:
                                                  'أكتب إسم المالك الجديد',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء إدخال إسم المالك';
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
                                        List<Map> existingOwnerName =
                                            await sqldb.selectRaw(
                                                'SELECT * FROM "owners" WHERE name = "${newnameController.text}" AND created_by = "${userController.currentUser.value.username}"');
                                        if (existingOwnerName.isNotEmpty) {
                                          Get.snackbar(
                                            'خطأ',
                                            'إسم المالك موجود مسبقا',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        } else {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(DateTime.now());
                                          // Update owner name
                                          await ownersController
                                              .updateOwnerNameUseingId(
                                            owner.id,
                                            ownerOldName,
                                            newnameController.text,
                                            userController
                                                .currentUser.value.username,
                                            formattedDate,
                                          );
                                          // Refresh the list
                                          await ownersController
                                              .fetchOwnersBasedOnCreatedBy(
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
                                  )..show();
                                },
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await ownersController.sqldb.delete(
                                    'owners',
                                    'id = "${owner.id}"',
                                  );
                                  // Refresh the list of owners
                                  await ownersController
                                      .fetchOwnersBasedOnCreatedBy(
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
