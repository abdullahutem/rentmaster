class RealStateModel {
  int id;
  String name;
  String typeid;
  int locationId;
  int isRentable;
  int parent_id;
  String description;
  String createdby;
  String createdate;
  String updatedby;
  String updatedate;

  RealStateModel({
    required this.id,
    required this.name,
    required this.typeid,
    required this.locationId,
    required this.isRentable,
    required this.parent_id,
    required this.description,
    required this.createdby,
    required this.createdate,
    required this.updatedby,
    required this.updatedate,
  });

  // Factory constructor to create a RealStateModel from a map (e.g., JSON)
  factory RealStateModel.fromJson(Map<String, dynamic> json) {
    return RealStateModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      typeid: json['type_id'],
      locationId: json['location_id'],
      isRentable: json['is_rentable'],
      parent_id: json['parent_id'],
      description: json['description'],
      createdby: json['created_by'] ?? '',
      createdate: json['create_date'] ?? '',
      updatedby: json['updated_by'] ?? '',
      updatedate: json['update_date'] ?? '',
      
    );
  }
}
