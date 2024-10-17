
import 'store_model.dart';
import '../user/model/user_model.dart';

class PostModel {
  final String idPosts;
  final String caption;
  final List<String> picture;
  final int favorite;
  final String idUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String idStore;
  final List<CommentModel> comments;
  final List<FavoriteModel> favorites;
  StoreModel? store;
  bool isFavoritedByUser;

  PostModel({
    required this.idPosts,
    required this.caption,
    required this.picture,
    required this.favorite,
    required this.idUser,
    required this.createdAt,
    required this.updatedAt,
    required this.idStore,
    required this.comments,
    required this.favorites,
    this.store,
    this.isFavoritedByUser =
        false, 
  });

  factory PostModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    List<FavoriteModel> favoritesList = List<FavoriteModel>.from(
      json['favorites'].map((x) => FavoriteModel.fromJson(x)),
    );

    bool isFavoritedByUser =
        favoritesList.any((fav) => fav.idUser == currentUserId);

    return PostModel(
      idPosts: json['idPosts'],
      caption: json['caption'],
      picture: List<String>.from(json['picture']),
      favorite: json['favorite'],
      idUser: json['idUser'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      idStore: json['idStore'],
      comments: List<CommentModel>.from(
          json['comments'].map((x) => CommentModel.fromJson(x))),
      favorites: favoritesList,
      store: json.containsKey('store') && json['store'] != null
          ? StoreModel.fromJson(json['store']) 
          : null,
      isFavoritedByUser: isFavoritedByUser, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPosts': idPosts,
      'caption': caption,
      'picture': picture,
      'favorite': favorite,
      'idUser': idUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'idStore': idStore,
      'comments': comments.map((x) => x.toJson()).toList(),
      'favorites': favorites.map((x) => x.toJson()).toList(),
      'store': store?.toJson(),
      'isFavoritedByUser': isFavoritedByUser,
    };
  }
}

class CommentModel {
  final String idComment;
  final String idUser;
  final String comment;
  final DateTime createdAt;
  UserModel? user; 

  CommentModel({
    required this.idComment,
    required this.idUser,
    required this.comment,
    required this.createdAt,
    this.user, 
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      idComment: json['idComment'],
      idUser: json['idUser'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json.containsKey('user') && json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idComment': idComment,
      'idUser': idUser,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}


class FavoriteModel {
  final String idFavorite;
  final String idUser;
  final String idPosts;

  FavoriteModel({
    required this.idFavorite,
    required this.idUser,
    required this.idPosts,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      idFavorite: json['idFavorite'],
      idUser: json['idUser'],
      idPosts: json['idPosts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFavorite': idFavorite,
      'idUser': idUser,
      'idPosts': idPosts,
    };
  }
}

