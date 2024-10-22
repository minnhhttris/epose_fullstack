// ignore_for_file: constant_identifier_names

import 'package:epose_app/core/configs/app_images_string.dart';

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
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      idBill: json['idBill'],
      idUser: json['idUser'],
      idStore: json['idStore'],
      sum: json['sum'].toDouble(),
      downpayment: json['downpayment'].toDouble(),
      dateStart: DateTime.parse(json['dateStart']),
      dateEnd: DateTime.parse(json['dateEnd']),
      statement: Statement.values
          .firstWhere((e) => e.toString().split('.').last == json['statement']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      billItems: List<BillItemModel>.from(
          json['billItems'].map((x) => BillItemModel.fromJson(x))),
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
    };
  }
}

class BillItemModel {
  String idBill;
  String idItem;

  BillItemModel({
    required this.idBill,
    required this.idItem,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      idBill: json['idBill'],
      idItem: json['idItem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBill': idBill,
      'idItem': idItem,
    };
  }
}

enum Statement {
  PAID, // đã thanh toán
  CONFIRMED, // xác nhận
  PENDING_PICKUP, // chờ lấy hàng
  DELIVERING, // đang giao
  DELIVERED, // đã giao
  CANCELLED, // đã hủy
  RETURNED, // trả hàng
  COMPLETED, // đã hoàn thành
}

final Map<Statement, Map<String, dynamic>> statementMapping = {
  Statement.PAID: {
    'label': 'Đã thanh toán',
    'icon': AppImagesString.ePaid,
  },
  Statement.CONFIRMED: {
    'label': 'Xác nhận',
    'icon': AppImagesString.eConfirmed,
  },
  Statement.PENDING_PICKUP: {
    'label': 'Chờ lấy hàng',
    'icon': AppImagesString.ePendingPickup,
  },
  Statement.DELIVERING: {
    'label': 'Đang giao',
    'icon': AppImagesString.eDelivering,
  },
  Statement.DELIVERED: {
    'label': 'Đã giao',
    'icon': AppImagesString.eDelivered,
  },
  Statement.CANCELLED: {
    'label': 'Đã hủy',
    'icon': AppImagesString.eCancelled,
  },
  Statement.RETURNED: {
    'label': 'Trả hàng',
    'icon': AppImagesString.eReturned,
  },
  Statement.COMPLETED: {
    'label': 'Hoàn thành',
    'icon': AppImagesString.eCompleted,
  },
};
