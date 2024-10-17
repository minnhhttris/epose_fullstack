class NotificationModel {
  String idNotification;
  String idUser;
  String idStore;
  String notification;
  DateTime createdAt;

  NotificationModel({
    required this.idNotification,
    required this.idUser,
    required this.idStore,
    required this.notification,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      idNotification: json['idNotification'],
      idUser: json['idUser'],
      idStore: json['idStore'],
      notification: json['notification'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNotification': idNotification,
      'idUser': idUser,
      'idStore': idStore,
      'notification': notification,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
