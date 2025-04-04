import 'package:get/get.dart';
import 'package:rentmaster/model/real_state_type_model.dart';
import 'package:rentmaster/model/sqldb.dart';

class Realstatetypecontroller extends GetxController {
  final Sqldb sqldb = Sqldb();

  var realStateTypeList = <RealStateTypeModel>[].obs;

  // Observable RealStateType object to manage RealStateType data
  var currentState = RealStateTypeModel(
    id: 0,
    name: '',
    createdby: '',
    createdate: '',
    updatedby: '',
    updatedate: '',
  ).obs;

  Future<void> fetchRealStateTypeList() async {
    try {
      // Fetch all RealStateTypeModel data
      List<Map> response =
          await sqldb.selectRaw('SELECT * FROM "real_state_type"');

      if (response.isNotEmpty) {
        // Map the response to realStateTypeList
        realStateTypeList.value = response.map((item) {
          return RealStateTypeModel(
            id: item['id'],
            name: item['name'] ?? '',
            createdby: item['created_by'] ?? '',
            createdate: item['create_date'] ?? '',
            updatedby: item['updated_by'] ?? '',
            updatedate: item['update_date'] ?? '',
          );
        }).toList();
      } else {
        Get.snackbar('Info', 'No RealStateType data available');
      }
    } catch (e) {
      print('Error fetching RealStateType data: $e');
      Get.snackbar('Error', 'Could not fetch RealStateType data');
    }
  }

  // Method to create a new RealStateType
  Future<void> createNewRealStateType(
      String name, String createdby, String createdate) async {
    try {
      // Prepare SQL command
      String sql =
          '''INSERT INTO real_state_type (name, created_by, create_date) 
                      VALUES ("$name", "$createdby", "$createdate")''';

      // Execute SQL command
      int result = await sqldb.insertData(sql);

      if (result > 0) {
        Get.snackbar('Success', 'RealStateType created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create RealStateType');
      }
    } catch (e) {
      print('Error creating RealStateType: $e');
      Get.snackbar('Error', 'Could not create RealStateType');
    }
  }

  Future<void> getRealStateTypeDataUsingName(
      String RealStateTypeModelname) async {
    try {
      // Fetch RealStateTypeModel data based on the RealStateTypeModelname
      List<Map> response = await sqldb.selectRaw(
          'SELECT * FROM "real_state_type" WHERE "name" = "$RealStateTypeModelname"');

      if (response.isNotEmpty) {
        // Map the response to currentRealStateTypeModel
        currentState.value = RealStateTypeModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          createdby: response[0]['created_by'] ?? '',
          createdate: response[0]['create_date'] ?? '',
          updatedby: response[0]['updated_by'] ?? '',
          updatedate: response[0]['update_date'] ?? '',
        );
      } else {
        Get.snackbar('Error', 'No RealStateTypeModel data found');
      }
    } catch (e) {
      print('Error fetching RealStateTypeModel data: $e');
      Get.snackbar('Error', 'Could not fetch RealStateTypeModel data');
    }
  }

  Future<int> getRealStateTypeId(String name) async {
    List<Map> response = await sqldb
        .selectRaw('SELECT * FROM "real_state_type" WHERE "name" = "$name"');
    if (response.isNotEmpty) {
      return response[0]['id'];
    } else {
      return 1;
    }
  }

  Future<void> getRealStateTypeModelData() async {
    try {
      List<Map> response =
          await sqldb.selectRaw('SELECT * FROM "real_state_type" ');

      if (response.isNotEmpty) {
        // Map the response to currentRealStateTypeModel
        currentState.value = RealStateTypeModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          createdby: response[0]['created_by'] ?? '',
          createdate: response[0]['create_date'] ?? '',
          updatedby: response[0]['updated_by'] ?? '',
          updatedate: response[0]['update_date'] ?? '',
        );
      } else {
        Get.snackbar('Error', 'No RealStateTypeModel data found');
      }
    } catch (e) {
      print('Error fetching RealStateTypeModel data: $e');
      Get.snackbar('Error', 'Could not fetch RealStateTypeModel data');
    }
  }

  // Method to update RealStateType data
  Future<void> updateRealStateType(RealStateTypeModel RealStateType) async {
    try {
      String sql = '''UPDATE real_state_type SET 
                      name = "${RealStateType.name}", 
                      updated_by = "${RealStateType.updatedby}", 
                      update_date = "${RealStateType.updatedate}" 
                      WHERE id = "${RealStateType.id}"''';

      int result = await sqldb.updateData(sql);

      if (result > 0) {
        currentState.value = RealStateType;
        Get.snackbar('Success', 'RealStateType updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update RealStateType');
      }
    } catch (e) {
      print('Error updating RealStateType: $e');
      Get.snackbar('Error', 'Could not update RealStateType');
    }
  }

  // Method to delete RealStateType by ID
  Future<void> deleteRealStateType(int id) async {
    try {
      String sql = 'DELETE FROM real_state_type WHERE id = $id';
      int result = await sqldb.deleteData(sql);

      if (result > 0) {
        currentState.value = RealStateTypeModel(
          id: 0,
          name: '',
          createdby: '',
          createdate: '',
          updatedby: '',
          updatedate: '',
        );
        Get.snackbar('Success', 'RealStateType deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete RealStateType');
      }
    } catch (e) {
      print('Error deleting RealStateType: $e');
      Get.snackbar('Error', 'Could not delete RealStateType');
    }
  }
}
