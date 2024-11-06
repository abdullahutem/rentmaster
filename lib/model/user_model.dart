class UserModel {
  int id;
  String name;
  String username;
  String email;
  String phonenumber;
  String password;
  String createdby;
  String createdate;
  String updatedby;
  String updatedate;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phonenumber,
    required this.password,
    required this.createdby,
    required this.createdate,
    required this.updatedby,
    required this.updatedate,
  });

  // Factory constructor to create a User from a map (e.g., JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['user_name'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phone_number'] ?? '',
      password: json['password'] ?? '',
      createdby: json['created_by'] ?? '',
      createdate: json['create_date'] ?? '',
      updatedby: json['updated_by'] ?? '',
      updatedate: json['update_date'] ?? '',
    );
  }

}
