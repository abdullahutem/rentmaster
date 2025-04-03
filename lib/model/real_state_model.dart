class RealStateModel {
  final int id;
  final String name;
  final String createdby;
  final String createdate;
  final String? updatedby;
  final String? updatedate;
  final int typeid;
  final int? locationId; // Nullable
  final int isRentable;
  final int rentStatus;
  final int parent_id; // Default to 0 if invalid
  final int price; // Default to 0 if invalid
  final String description;
  final int currency_id;

  RealStateModel({
    required this.id,
    required this.name,
    required this.createdby,
    required this.createdate,
    this.updatedby,
    this.updatedate,
    required this.typeid,
    this.locationId,
    required this.isRentable,
    required this.rentStatus,
    required this.parent_id,
    required this.price,
    required this.description,
    required this.currency_id,
  });
}
