// ignore_for_file: constant_identifier_names

import 'store_model.dart';

class ClothesModel {
  final String idItem;
  final String nameItem;
  final String description;
  final double price;
  final List<String> listPicture;
  final double rate;
  final int favorite;
  final Color color;
  final Style style;
  final Gender gender;
  final int number;
  final String idStore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ItemSize> itemSizes;
  StoreModel? store;

  ClothesModel({
    required this.idItem,
    required this.nameItem,
    required this.description,
    required this.price,
    required this.listPicture,
    required this.rate,
    required this.favorite,
    required this.color,
    required this.style,
    required this.gender,
    required this.number,
    required this.idStore,
    required this.createdAt,
    required this.updatedAt,
    required this.itemSizes,
    this.store,
  });

  factory ClothesModel.fromJson(Map<String, dynamic> json) {
    return ClothesModel(
      idItem: json['idItem'],
      nameItem: json['nameItem'],
      description: json['description'],
      price: json['price'].toDouble(),
      listPicture: List<String>.from(json['listPicture']),
      rate: json['rate'].toDouble(),
      favorite: json['favorite'],
      color: Color.values
          .firstWhere((e) => e.toString().split('.').last == json['color']),
      style: Style.values
          .firstWhere((e) => e.toString().split('.').last == json['style']),
      gender: Gender.values
          .firstWhere((e) => e.toString().split('.').last == json['gender']),
      number: json['number'],
      idStore: json['idStore'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      itemSizes:
          (json['itemSizes'] as List).map((i) => ItemSize.fromJson(i)).toList(),
      store: json.containsKey('store') && json['store'] != null
          ? StoreModel.fromJson(json['store'])
          : null,
    );
  }
}

class ItemSize {
  final String idItemSize;
  final String idItem;
  final SizeEnum size;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemSize({
    required this.idItemSize,
    required this.idItem,
    required this.size,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemSize.fromJson(Map<String, dynamic> json) {
    return ItemSize(
      idItemSize: json['idItemSize'],
      idItem: json['idItem'],
      size: SizeEnum.values
          .firstWhere((e) => e.toString().split('.').last == json['size']),
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}


enum Color {
  red,
  blue,
  green,
  yellow,
  black,
  white,
  pink,
  purple,
  orange,
  brown,
  gray,
  beige,
  colorfull,
}

enum Style {
  ao_dai,
  tu_than,
  co_phuc,
  ao_ba_ba,
  da_hoi,
  nang_tho,
  hoc_duong,
  vintage,
  ca_tinh,
  sexy,
  cong_so,
  dan_toc,
  do_doi,
  hoa_trang,
  cac_nuoc,
}

enum SizeEnum {
  S,
  M,
  L,
  XL,
}

enum Status {
  active,
  inactive,
}

enum Gender {
  male,
  female,
  unisex,
  other,
}
