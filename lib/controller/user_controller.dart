import 'package:get/get.dart';
import 'package:rentmaster/model/sqldb.dart';
import 'package:rentmaster/model/user_model.dart';

class UserController extends GetxController {
  final Sqldb sqldb = Sqldb();

  // Observable User object to manage user data
  var currentUser = UserModel(
    id: 0,
    name: '',
    username: '',
    email: '',
    phonenumber: '',
    password: '',
    createdby: '',
    createdate: '',
    updatedby: '',
    updatedate: '',
  ).obs;

  // Method to create a new user
  Future<void> createNewUser(String name, String username, String email, 
                             String phonenumber, String password, 
                             String createdby, String createdate) async {
    try {
      // Prepare SQL command
      String sql = '''INSERT INTO users (name, user_name, email, phone_number, password, created_by, create_date) 
                      VALUES ("$name", "$username", "$email", "$phonenumber", "$password", "$createdby", "$createdate")''';

      // Execute SQL command
      int result = await sqldb.insertData(sql);

      if (result > 0) {
        Get.snackbar('Success', 'User created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create user');
      }
    } catch (e) {
      print('Error creating user: $e');
      Get.snackbar('Error', 'Could not create user');
    }
  }

  Future<void> getUserData(String username) async {
  try {
    // Fetch user data based on the username
    List<Map> response = await sqldb.selectRaw(
        'SELECT * FROM "users" WHERE "user_name" = "$username"');

    if (response.isNotEmpty) {
      // Map the response to currentUser
      currentUser.value = UserModel(
        id: response[0]['id'],
        name: response[0]['name'] ?? '',
        username: response[0]['user_name'] ?? '',
        email: response[0]['email'] ?? '',
        phonenumber: response[0]['phone_number'] ?? '',
        password: response[0]['password'] ?? '',
        createdby: response[0]['created_by'] ?? '',
        createdate: response[0]['create_date'] ?? '',
        updatedby: response[0]['updated_by'] ?? '',
        updatedate: response[0]['update_date'] ?? '',
      );
    } else {
      Get.snackbar('Error', 'No user data found');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    Get.snackbar('Error', 'Could not fetch user data');
  }
}


  Future<bool> checkLogin(String username, String password) async {
    List<Map> response = await sqldb.selectData(
      "SELECT * FROM users WHERE user_name = ? AND password = ?",
      [username, password],
    );
    return response.isNotEmpty;
  }

  // Method to update user data
  Future<void> updateUser(UserModel user) async {
    try {
      String sql = '''UPDATE users SET 
                      name = "${user.name}", 
                      email = "${user.email}", 
                      phone_number = "${user.phonenumber}", 
                      updated_by = "${user.updatedby}", 
                      update_date = "${user.updatedate}" 
                      WHERE user_name = "${user.username}"''';

      int result = await sqldb.updateData(sql);

      if (result > 0) {
        currentUser.value = user;
        Get.snackbar('Success', 'User updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update user');
      }
    } catch (e) {
      print('Error updating user: $e');
      Get.snackbar('Error', 'Could not update user');
    }
  }

  // Method to delete user by ID
  Future<void> deleteUser(int id) async {
    try {
      String sql = 'DELETE FROM users WHERE id = $id';
      int result = await sqldb.deleteData(sql);

      if (result > 0) {
        currentUser.value = UserModel(
          id: 0,
          name: '',
          username: '',
          email: '',
          phonenumber: '',
          password: '',
          createdby: '',
          createdate: '',
          updatedby: '',
          updatedate: '',
        );
        Get.snackbar('Success', 'User deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user: $e');
      Get.snackbar('Error', 'Could not delete user');
    }
  }
}
