import 'package:get/get.dart';
import 'package:rentmaster/model/owners_model.dart';
import 'package:rentmaster/model/sqldb.dart';

class OwnersController extends GetxController {
  final Sqldb sqldb = Sqldb();
  var ownersList = <OwnersModel>[].obs;

  // Observable Owners object to manage Owners data
  var currentOwner = OwnersModel(
    id: 0,
    name: '',
    createdby: '',
    createdate: '',
    updatedby: '',
    updatedate: '',
  ).obs;

  Future<void> fetchOwners() async {
    try {
      List<Map> response = await sqldb.selectRaw('select * from "owners"');
      if (response.isNotEmpty) {
        ownersList.value = response.map((item) {
          return OwnersModel(
            id: item['id'],
            name: item['name'] ?? '',
            createdby: item['created_by'] ?? '',
            createdate: item['create_date'] ?? '',
            updatedby: item['updated_by'] ?? '',
            updatedate: item['update_date'] ?? '',
          );
        }).toList();
      } else {
        Get.snackbar('Info', 'No Owners data available');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Could not fetch Owners data');
    }
  }

  Future<void> fetchOwnersBasedOnCreatedBy(String created_by) async {
    try {
      List<Map> response = await sqldb
          .selectRaw('select * from "owners" WHERE created_by="$created_by"');
      if (response.isNotEmpty) {
        ownersList.value = response.map((item) {
          return OwnersModel(
            id: item['id'],
            name: item['name'] ?? '',
            createdby: item['created_by'] ?? '',
            createdate: item['create_date'] ?? '',
            updatedby: item['updated_by'] ?? '',
            updatedate: item['update_date'] ?? '',
          );
        }).toList();
      } else {
        Get.snackbar('Info', 'No Owners data available');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Could not fetch Owners data');
    }
  }

  Future<void> createNewOwners(
      String name, String created_by, String create_date) async {
    try {
      String sql = '''INSERT INTO "owners" (name,created_by,create_date) 
          VALUES ("$name","$created_by","$create_date")''';
      int result = await sqldb.insertData(sql);
      if (result > 0) {
        Get.snackbar('Success', 'Owners created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create Owners');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Could not create Owners');
    }
  }

  Future<void> getOwnerDataUsingName(String name) async {
    try {
      List<Map> response =
          await sqldb.selectRaw('SELECT * FROM "owners" WHERE name = "$name"');
      if (response.isNotEmpty) {
        currentOwner.value = OwnersModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          createdby: response[0]['created_by'] ?? '',
          createdate: response[0]['create_date'] ?? '',
          updatedby: response[0]['updated_by'] ?? '',
          updatedate: response[0]['update_date'] ?? '',
        );
      } else {
        Get.snackbar('Error', 'No OwnersModel data found');
      }
    } catch (e) {
      print('Error fetching OwnersModel data: $e');
      Get.snackbar('Error', 'Could not fetch OwnersModel data');
    }
  }

  Future<int> getOwnerId(String name) async {
    List<Map> response =
        await sqldb.selectRaw('SELECT "id" FROM "owners" WHERE name = "$name"');
    if (response.isNotEmpty) {
      return response[0]['id'];
    } else {
      return 0;
    }
  }

  Future<String> getOwnerName(int id) async {
    List<Map> response =
        await sqldb.selectRaw('SELECT "name" FROM "owners" WHERE id = "$id"');
    if (response.isNotEmpty) {
      return response[0]['name'];
    } else {
      return 'not found';
    }
  }

  Future<void> updateOwnerNameUseingId(int id, String oldname, String newname,
      String updatedby, String updatedate) async {
    String sql = '''UPDATE owners SET 
                      name = "$newname",  
                      updated_by = "$updatedby", 
                      update_date = "$updatedate" 
                      WHERE id = "$id" AND name="$oldname"''';

    int result = await sqldb.updateData(sql);

    if (result > 0) {
      Get.snackbar('Success', 'Owner name updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update Owner name');
    }
  }

  Future<void> getOwnersModelData() async {
    try {
      List<Map> response = await sqldb.selectRaw('SELECT * FROM "owners"');
      if (response.isNotEmpty) {
        // Map the response to currentOwnersModel
        currentOwner.value = OwnersModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          createdby: response[0]['created_by'] ?? '',
          createdate: response[0]['create_date'] ?? '',
          updatedby: response[0]['updated_by'] ?? '',
          updatedate: response[0]['update_date'] ?? '',
        );
      } else {
        Get.snackbar('Error', 'No OwnersModel data found');
      }
    } catch (e) {
      print('Error fetching OwnersModel data: $e');
      Get.snackbar('Error', 'Could not fetch OwnersModel data');
    }
  }
}
