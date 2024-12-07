// ignore_for_file: constant_identifier_names

import '../user/model/user_model.dart';
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
  List<ItemSize> itemSizes;
  StoreModel? store;
  List<RatingModel> ratings;

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
    this.ratings = const [],
  });

  factory ClothesModel.fromJson(Map<String, dynamic> json) {
    return ClothesModel(
      idItem: json['idItem'] ?? '',
      nameItem: json['nameItem'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0) .toDouble(),
      listPicture: json['listPicture'] != null
          ? List<String>.from(json['listPicture'])
          : [],
      rate: (json['rate'] ?? 0).toDouble(),
      favorite: json['favorite'] ?? 0,
      color: Color.values.firstWhere(
        (e) => e.toString().split('.').last == (json['color'] ?? 'red'),
        orElse: () => Color.red,
      ),
      style: Style.values.firstWhere(
        (e) => e.toString().split('.').last == (json['style'] ?? 'ao_dai'),
        orElse: () => Style.ao_dai,
      ),
      gender: Gender.values.firstWhere(
        (e) => e.toString().split('.').last == (json['gender'] ?? 'unisex'),
        orElse: () => Gender.unisex,
      ),
      number: json['number'] ?? 0,
      idStore: json['idStore'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      itemSizes:
          (json['itemSizes'] as List).map((i) => ItemSize.fromJson(i)).toList(),
      ratings: json['rating'] != null
          ? (json['rating'] as List)
              .map((rating) => RatingModel.fromJson(rating))
              .toList()
          : [],
      store: json.containsKey('store') && json['store'] != null
          ? StoreModel.fromJson(json['store'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idItem': idItem,
      'nameItem': nameItem,
      'description': description,
      'price': price,
      'listPicture': listPicture,
      'rate': rate,
      'favorite': favorite,
      'color': color.toString().split('.').last,
      'style': style.toString().split('.').last,
      'gender': gender.toString().split('.').last,
      'number': number,
      'idStore': idStore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'itemSizes': itemSizes.map((e) => e.toJson()).toList(),
      'store': store?.toJson(),
      'rating': ratings.map((e) => e.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'idItemSize': idItemSize,
      'idItem': idItem,
      'size': size.toString().split('.').last,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RatingModel {
  final String idRating;
  final String idUser;
  final double ratingStar;
  final String? ratingComment;
  final DateTime createdAt;
  final UserModel? user;

  RatingModel({
    required this.idRating,
    required this.idUser,
    required this.ratingStar,
    this.ratingComment,
    required this.createdAt,
    this.user, 
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      idRating: json['idRating'] ?? '',
      idUser: json['idUser'] ?? '',
      ratingStar: (json['ratingstar'] ?? 0).toDouble(),
      ratingComment: json['ratingcomment'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json.containsKey('user') && json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRating': idRating,
      'idUser': idUser,
      'ratingstar': ratingStar,
      'ratingcomment': ratingComment,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(),
    };
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

enum Gender {
  male,
  female,
  unisex,
  other,
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


