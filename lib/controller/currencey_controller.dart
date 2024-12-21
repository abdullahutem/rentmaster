import 'package:get/get.dart';
import 'package:rentmaster/model/currency_model.dart';
import 'package:rentmaster/model/sqldb.dart';

class CurrenceyController extends GetxController {
  final Sqldb sqldb = Sqldb();

  var currencyList = <CurrencyModel>[].obs;

  // Observable Currency object to manage Currency data
  var currentState = CurrencyModel(
    id: 0,
    name: '',
    currency_code: '',
    symbol: '',
  ).obs;

  Future<void> fetchCurrencyList() async {
    try {
      // Fetch all CurrencyModel data
      List<Map> response = await sqldb.selectRaw('SELECT * FROM "currency"');

      if (response.isNotEmpty) {
        // Map the response to currencyList
        currencyList.value = response.map((item) {
          return CurrencyModel(
            id: item['id'],
            name: item['name'] ?? '',
            currency_code: '',
            symbol: '',
          );
        }).toList();
      } else {
        Get.snackbar('Info', 'No Currency data available');
      }
    } catch (e) {
      print('Error fetching Currency data: $e');
      Get.snackbar('Error', 'Could not fetch Currency data');
    }
  }

  // Method to create a new Currency
  Future<void> createNewCurrency(
      String name, String createdby, String createdate) async {
    try {
      // Prepare SQL command
      String sql = '''INSERT INTO currency (name, created_by, create_date) 
                      VALUES ("$name", "$createdby", "$createdate")''';

      // Execute SQL command
      int result = await sqldb.insertData(sql);

      if (result > 0) {
        Get.snackbar('Success', 'Currency created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create Currency');
      }
    } catch (e) {
      print('Error creating Currency: $e');
      Get.snackbar('Error', 'Could not create Currency');
    }
  }

  Future<void> getCurrencyDataUsingName(String CurrencyModelname) async {
    try {
      // Fetch CurrencyModel data based on the CurrencyModelname
      List<Map> response = await sqldb.selectRaw(
          'SELECT * FROM "currency" WHERE "name" = "$CurrencyModelname"');

      if (response.isNotEmpty) {
        // Map the response to currentCurrencyModel
        currentState.value = CurrencyModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          currency_code: '',
          symbol: '',
        );
      } else {
        Get.snackbar('Error', 'No CurrencyModel data found');
      }
    } catch (e) {
      print('Error fetching CurrencyModel data: $e');
      Get.snackbar('Error', 'Could not fetch CurrencyModel data');
    }
  }

  Future<int> getCurrencyId(String name) async {
    List<Map> response = await sqldb
        .selectRaw('SELECT * FROM "currency" WHERE "name" = "$name"');
    if (response.isNotEmpty) {
      return response[0]['id'];
    } else {
      return 1;
    }
  }

  Future<void> getCurrencyModelData() async {
    try {
      List<Map> response = await sqldb.selectRaw('SELECT * FROM "currency" ');

      if (response.isNotEmpty) {
        // Map the response to currentCurrencyModel
        currentState.value = CurrencyModel(
          id: response[0]['id'],
          name: response[0]['name'] ?? '',
          currency_code: '',
          symbol: '',
        );
      } else {
        Get.snackbar('Error', 'No CurrencyModel data found');
      }
    } catch (e) {
      print('Error fetching CurrencyModel data: $e');
      Get.snackbar('Error', 'Could not fetch CurrencyModel data');
    }
  }

  // Method to update Currency data
  Future<void> updateCurrency(CurrencyModel Currency) async {
    try {
      String sql = '''UPDATE currency SET 
                      name = "${Currency.name}", 
                      WHERE id = "${Currency.id}"''';

      int result = await sqldb.updateData(sql);

      if (result > 0) {
        currentState.value = Currency;
        Get.snackbar('Success', 'Currency updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update Currency');
      }
    } catch (e) {
      print('Error updating Currency: $e');
      Get.snackbar('Error', 'Could not update Currency');
    }
  }

  // Method to delete Currency by ID
  Future<void> deleteCurrency(int id) async {
    try {
      String sql = 'DELETE FROM currency WHERE id = $id';
      int result = await sqldb.deleteData(sql);

      if (result > 0) {
        currentState.value = CurrencyModel(
          id: 0,
          name: '',
          currency_code: '',
          symbol: '',
        );
        Get.snackbar('Success', 'Currency deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete Currency');
      }
    } catch (e) {
      print('Error deleting Currency: $e');
      Get.snackbar('Error', 'Could not delete Currency');
    }
  }
}
