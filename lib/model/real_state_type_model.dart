class RealStateTypeModel {
  int id;
  String name;
  String createdby;
  String createdate;
  String updatedby;
  String updatedate;

  RealStateTypeModel({
    required this.id,
    required this.name,
    required this.createdby,
    required this.createdate,
    required this.updatedby,
    required this.updatedate,
  });

  // Factory constructor to create a User from a map (e.g., JSON)
  factory RealStateTypeModel.fromJson(Map<String, dynamic> json) {
    return RealStateTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdby: json['created_by'] ?? '',
      createdate: json['create_date'] ?? '',
      updatedby: json['updated_by'] ?? '',
      updatedate: json['update_date'] ?? '',
    );
  }
}