class StoreModel {
  String idStore;
  final String idUser;
  final String nameStore;
  final String license;
  final String taxCode;
  final String logo;
  final String address;
  double rate;
  Status status;
  DateTime createdAt;
  DateTime updatedAt;
  List<StoreUserModel>? user; 

  StoreModel({
    required this.idStore,
    required this.idUser,
    required this.nameStore,
    required this.license,
    required this.taxCode,
    required this.logo,
    required this.address,
    required this.rate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      idStore: json['idStore'],
      idUser: json['idUser'],
      nameStore: json['nameStore'],
      license: json['license'],
      taxCode: json['taxCode'],
      logo: json['logo'],
      address: json['address'],
      rate: (json['rate'] as num).toDouble(),
      status: Status.values.firstWhere(
        (e) => e.toString() == 'Status.' + json['status'],
        orElse: () => Status.inactive, // Default to inactive if not found
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      // Check if 'user' exists, is not null, and is a list before parsing
      user: json['user'] != null && json['user'] is List
          ? (json['user'] as List)
              .map((userJson) => StoreUserModel.fromJson(userJson))
              .toList()
          : [], // Default to an empty list if null or invalid
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idStore': idStore,
      'idUser': idUser,
      'nameStore': nameStore,
      'license': license,
      'taxCode': taxCode,
      'logo': logo,
      'address': address,
      'rate': rate,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user != null
          ? user!.map((u) => u.toJson()).toList()
          : [], 
    };
  }
}


class StoreUserModel {
  final String idStore;
  final String idUser;
  final Role role; 

  StoreUserModel({
    required this.idStore,
    required this.idUser,
    required this.role,
  });

  factory StoreUserModel.fromJson(Map<String, dynamic> json) {
    return StoreUserModel(
      idStore: json['idStore'],
      idUser: json['idUser'],
      role: Role.values.firstWhere(
        (e) => e.toString() == 'Role.' + json['role'],
        orElse: () => Role.user, // Giá trị mặc định nếu không tìm thấy vai trò
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idStore': idStore,
      'idUser': idUser,
      'role': role.toString(),
    };
  }
}

enum Status { active, inactive }

enum Role { owner, employee, user, admin }
