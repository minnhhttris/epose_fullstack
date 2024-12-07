import '../user/model/user_model.dart';
import 'clothes_model.dart';

import 'store_model.dart';

class BillModel {
  String idBill;
  String idUser;
  String idStore;
  double sum;
  double downpayment;
  DateTime dateStart;
  DateTime dateEnd;
  Statement statement;
  DateTime createdAt;
  DateTime updatedAt;
  List<BillItemModel> billItems;
  UserModel? user; 
  StoreModel? store; 

  BillModel({
    required this.idBill,
    required this.idUser,
    required this.idStore,
    required this.sum,
    required this.downpayment,
    required this.dateStart,
    required this.dateEnd,
    required this.statement,
    required this.createdAt,
    required this.updatedAt,
    required this.billItems,
    this.user, 
    this.store, 
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      idBill: json['idBill'] ?? '',
      idUser: json['idUser'] ?? '',
      idStore: json['idStore'] ?? '',
      sum: (json['sum'] ?? 0).toDouble(),
      downpayment: (json['downpayment'] ?? 0).toDouble(),
      dateStart: DateTime.parse(json['dateStart']),
      dateEnd: DateTime.parse(json['dateEnd']),
      statement: Statement.values
          .firstWhere((e) => e.toString().split('.').last == json['statement']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      billItems: (json['billItems'] as List)
          .map((x) => BillItemModel.fromJson(x))
          .toList(),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null, 
      store: json['store'] != null
          ? StoreModel.fromJson(json['store'])
          : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBill': idBill,
      'idUser': idUser,
      'idStore': idStore,
      'sum': sum,
      'downpayment': downpayment,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'statement': statement.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'billItems': billItems.map((x) => x.toJson()).toList(),
      'user': user?.toJson(), 
      'store': store?.toJson(), 
    };
  }
}


class BillItemModel {
  String idBill;
  String idItem;
  String size;
  int quantity;
  ClothesModel clothes;

  BillItemModel({
    required this.idBill,
    required this.idItem,
    required this.size,
    required this.quantity,
    required this.clothes,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      idBill: json['idBill'] ?? '',
      idItem: json['idItem'] ?? '',
      size: json['size'] ?? '',
      quantity: json['quantity'] ?? 0,
      clothes: ClothesModel.fromJson(json['clothes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBill': idBill,
      'idItem': idItem,
      'size': size,
      'quantity': quantity,
      'clothes': clothes.toJson(),
    };
  }
}

enum Statement {
  CREATE, // tạo mới
  UNPAID, 
  PAID, // đã thanh toán
  CONFIRMED, // xác nhận
  PENDING_PICKUP, // chờ lấy hàng
  DELIVERING, // đang giao
  DELIVERED, // đã giao
  CANCELLED, // đã hủy
  RETURNED, // trả hàng
  COMPLETED, // đã hoàn thành
  RATING, // đánh giá
}
