class BagShoppingModel {
  String idBag;
  String idUser;
  List<BagItemModel> items;
  DateTime createdAt;
  DateTime updatedAt;

  BagShoppingModel({
    required this.idBag,
    required this.idUser,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BagShoppingModel.fromJson(Map<String, dynamic> json) {
    return BagShoppingModel(
      idBag: json['idBag'],
      idUser: json['idUser'],
      items: List<BagItemModel>.from(
          json['items'].map((x) => BagItemModel.fromJson(x))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBag': idBag,
      'idUser': idUser,
      'items': items.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class BagItemModel {
  String idBagItem;
  String idBag;
  String idItem;
  String idStore;
  int quantity;

  BagItemModel({
    required this.idBagItem,
    required this.idBag,
    required this.idItem,
    required this.idStore,
    required this.quantity,
  });

  factory BagItemModel.fromJson(Map<String, dynamic> json) {
    return BagItemModel(
      idBagItem: json['idBagItem'],
      idBag: json['idBag'],
      idItem: json['idItem'],
      idStore: json['idStore'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBagItem': idBagItem,
      'idBag': idBag,
      'idItem': idItem,
      'idStore': idStore,
      'quantity': quantity,
    };
  }
}

