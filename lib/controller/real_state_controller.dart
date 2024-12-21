import 'package:get/get.dart';
import 'package:rentmaster/model/real_state_model.dart';
import 'package:rentmaster/model/sqldb.dart';

class RealStateController extends GetxController {
  final Sqldb sqldb = Sqldb();

  var realStateList = <RealStateModel>[].obs;

  // Observable RealState object to manage RealState data
  var currentState = RealStateModel(
          id: 0,
          name: '',
          typeid: 0,
          locationId: 0,
          isRentable: 0,
          parent_id: 0,
          description: '',
          createdby: '',
          createdate: '',
          updatedby: '',
          updatedate: '',
          price: 0,
          currency_id: 0)
      .obs;

  // Method to create a new RealState
  Future<void> createNewRealState(String name, String typeid, int locationId,
      int isRentable, String createdby, String createdate) async {
    try {
      // Prepare SQL command
      String sql =
          '''INSERT INTO real_state (name, type_id, location_id, is_rentable, created_by, create_date) 
              VALUES ("$name", "$typeid", $locationId, $isRentable, "$createdby", "$createdate")''';

      // Execute SQL command
      int result = await sqldb.insertData(sql);

      if (result > 0) {
        Get.snackbar('Success', 'RealState created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create RealState');
      }
    } catch (e) {
      print('Error creating RealState: $e');
      Get.snackbar('Error', 'Could not create RealState');
    }
  }

  // Future<void> getRealStateDataUsingName(String realStateName) async {
  //   try {
  //     // Fetch RealState data based on the name
  //     List<Map> response = await sqldb.selectRaw(
  //         'SELECT * FROM "real_state" WHERE "name" = "$realStateName"');

  //     if (response.isNotEmpty) {
  //       // Map the response to currentState
  //       currentState.value = RealStateModel(
  //         id: response[0]['id'],
  //         name: response[0]['name'] ?? '',
  //         typeid: response[0]['type_id'] ?? '',
  //         locationId: response[0]['location_id'] ?? 0,
  //         isRentable: response[0]['is_rentable'] ?? 0,
  //         parent_id: response[0]['parent_id'] ?? 0,
  //         description: response[0]['description'] ?? '',
  //         createdby: response[0]['created_by'] ?? '',
  //         createdate: response[0]['create_date'] ?? '',
  //         updatedby: response[0]['updated_by'] ?? '',
  //         updatedate: response[0]['update_date'] ?? '',
  //       );
  //     } else {
  //       Get.snackbar('Error', 'No RealState data found');
  //     }
  //   } catch (e) {
  //     print('Error fetching RealState data: $e');
  //     Get.snackbar('Error', 'Could not fetch RealState data');
  //   }
  // }

 Future<void> fetchRealStateParentsBasedOnCreatedBy(String created_by) async {
  print('Fetching RealState for created_by: $created_by');
  try {
    List<Map> response = await sqldb.selectRaw(
        'SELECT * FROM "real_state" WHERE created_by="$created_by"');
    print('====================MODEL======================Database Response: $response');

    if (response.isNotEmpty) {
      realStateList.value = response.map((item) {
        return RealStateModel(
          id: item['id'] as int,
          name: item['name'] ?? '',
          createdby: item['created_by'] ?? '',
          createdate: item['create_date'] ?? '',
          updatedby: item['updated_by'], // Nullable
          updatedate: item['update_date'], // Nullable
          typeid: item['type_id'] as int,
          locationId: item['location_id'] != null 
              ? int.tryParse(item['location_id'].toString()) ?? 0 
              : null, // Nullable
          isRentable: item['is_rentable'] as int,
          parent_id: item['parent_id'] != null 
              ? int.tryParse(item['parent_id'].toString()) ?? 0 
              : 0, // Default to 0 if null or invalid
          price: item['price'] != null 
              ? int.tryParse(item['price'].toString()) ?? 0 
              : 0, // Default to 0 if null or invalid
          description: item['description'] ?? '',
          currency_id: item['currency_id'] as int,
        );
      }).toList();
    } else {
      print('No data found for created_by: $created_by');
      Get.snackbar('Error', 'No RealState data found');
    }
  } catch (e) {
    print('Error fetching RealState data: $e');
    Get.snackbar('Error', 'Could not fetch RealState data');
  }
}




  Future<void> getRealStateData() async {
    try {
      List<Map> response = await sqldb.selectRaw('SELECT * FROM "real_state"');

      if (response.isNotEmpty) {
        realStateList.value = response
            .map((data) => RealStateModel(
                  id: data['id'],
                  name: data['name'] ?? '',
                  typeid: data['type_id'] ?? '',
                  locationId: data['location_id'] ?? 0,
                  isRentable: data['is_rentable'] ?? 0,
                  parent_id: data['parent_id'] ?? 0,
                  price: data['price'] ?? 0,
                  currency_id: data['currency_id'] ?? 0,
                  description: data['description'] ?? '',
                  createdby: data['created_by'] ?? '',
                  createdate: data['create_date'] ?? '',
                  updatedby: data['updated_by'] ?? '',
                  updatedate: data['update_date'] ?? '',
                ))
            .toList();
      } else {
        Get.snackbar('Error', 'No RealState data found');
      }
    } catch (e) {
      print('Error fetching RealState data: $e');
      Get.snackbar('Error', 'Could not fetch RealState data');
    }
  }
}
