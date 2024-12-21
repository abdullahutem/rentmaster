import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:rentmaster/model/tenants_model.dart';

class TenantsController extends GetxController {
  final Sqldb sqldb = Sqldb();
  var tenantsList = <TenantsModel>[].obs;

  // Observable Tenants object to manage Tenants data
  var currentTenant = TenantsModel(
    id: 0,
    name: '',
    phone_number: '',
    createdby: '',
    createdate: '',
    updatedby: '',
    updatedate: '', 
  ).obs;

  Future<void> fetchTenants() async {
    try {
      List<Map> response = await sqldb.selectRaw('select * from "tenants"');
      if (response.isNotEmpty) {
        tenantsList.value = response.map((item) {
          return TenantsModel(
            id: item['id'],
            name: item['name'] ?? '',
            phone_number: item['phone_number'] ?? '',
            createdby: item['created_by'] ?? '',
            createdate: item['create_date'] ?? '',
            updatedby: item['updated_by'] ?? '',
            updatedate: item['update_date'] ?? '', 
          );
        }).toList();
      } else {
        Get.snackbar('Info', 'No Tenants data available');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Could not fetch Tenants data');
    }
  }

  Future<void> fetchTenantsBasedOnCreatedBy(String created_by) async {
    try {
      List<Map> response = await sqldb
          .selectRaw('select * from "tenants" WHERE created_by="$created_by"');
      if (response.isNotEmpty) {
        tenantsList.value = response.map((item) {
          return TenantsModel(
            id: item['id'],
            name: item['name'] ?? '',
            phone_number: item['phone_number'] ?? '',
            createdby: item['created_by'] ?? '',
            createdate: item['create_date'] ?? '',
            updatedby: item['updated_by'] ?? '',
            updatedate: item['update_date'] ?? '',
          );
        }).toList();
      } else {
        Get.snackbar('Info', 'No Tenants data available');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Could not fetch Tenants data');
    }
  }

  Future<void> createNewTenants(
      String name, String phone_number, String created_by, String create_date) async {
    try {
      String sql = '''INSERT INTO "tenants" (name,phone_number,created_by,create_date) 
          VALUES ("$name","$phone_number","$created_by","$create_date")''';
      int result = await sqldb.insertData(sql);
      if (result > 0) {
        Get.snackbar('Success', 'Tenants created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create Tenants');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Could not create Tenants');
    }
  }

  Future<void> getTenantsDataUsingName(String name) async {
    try {
      List<Map> response =
          await sqldb.selectRaw('SELECT * FROM "tenants" WHERE name = "$name"');
      if (response.isNotEmpty) {
        currentTenant.value = TenantsModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          phone_number: response[0]['phone_number'] ?? '',
          createdby: response[0]['created_by'] ?? '',
          createdate: response[0]['create_date'] ?? '',
          updatedby: response[0]['updated_by'] ?? '',
          updatedate: response[0]['update_date'] ?? '',
        );
      } else {
        Get.snackbar('Error', 'No TenantsModel data found');
      }
    } catch (e) {
      print('Error fetching TenantsModel data: $e');
      Get.snackbar('Error', 'Could not fetch TenantsModel data');
    }
  }

  Future<int> getTenantsId(String name) async {
    List<Map> response =
        await sqldb.selectRaw('SELECT "id" FROM "tenants" WHERE name = "$name"');
    if (response.isNotEmpty) {
      return response[0]['id'];
    } else {
      return 0;
    }
  }

  Future<String> getTenantsName(int id) async {
    List<Map> response =
        await sqldb.selectRaw('SELECT "name" FROM "tenants" WHERE id = "$id"');
    if (response.isNotEmpty) {
      return response[0]['name'];
    } else {
      return 'not found';
    }
  }

  Future<void> updateTenantsNameUseingId(int id, String oldname, String newname,
      String updatedby, String updatedate) async {
    String sql = '''UPDATE tenants SET 
                      name = "$newname",  
                      updated_by = "$updatedby", 
                      update_date = "$updatedate" 
                      WHERE id = "$id" AND name="$oldname"''';

    int result = await sqldb.updateData(sql);

    if (result > 0) {
      Get.snackbar('تم', 'تم تعديل إسم المستاجر', backgroundColor: Colors.green,colorText: Colors.white,);
    } else {
      Get.snackbar('خطأ', 'لم يتم تعديل إسم المستاجر');
    }
  }

  Future<void> getTenantsModelData() async {
    try {
      List<Map> response = await sqldb.selectRaw('SELECT * FROM "tenants"');
      if (response.isNotEmpty) {
        // Map the response to currentTenantsModel
        currentTenant.value = TenantsModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          phone_number: response[0]['phone_number'] ?? '',
          createdby: response[0]['created_by'] ?? '',
          createdate: response[0]['create_date'] ?? '',
          updatedby: response[0]['updated_by'] ?? '',
          updatedate: response[0]['update_date'] ?? '',
        );
      } else {
        Get.snackbar('Error', 'No TenantsModel data found');
      }
    } catch (e) {
      print('Error fetching TenantsModel data: $e');
      Get.snackbar('Error', 'Could not fetch TenantsModel data');
    }
  }
}
