import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/ui/widgets/avatar/avatar.dart';
import '../controller/message_controller.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách trò chuyện')),
      body: Column(
        children: [
          // Hộp thoại tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm người dùng',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                controller.users.value = controller.users
                    .where((user) => (user.userName ?? user.email)
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              },
            ),
          ),

          // Hiển thị danh sách hội thoại và danh sách người dùng
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        // Danh sách các cuộc hội thoại
                        if (controller.conversations.isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Danh sách hội thoại',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.conversations.length,
                                    itemBuilder: (context, index) {
                                      final conversation =
                                          controller.conversations[index];
                                      final otherUser =
                                          conversation['otherUser'];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              otherUser['avatar'] ?? ''),
                                        ),
                                        title: Text(otherUser['userName'] ??
                                            otherUser['email']),
                                        subtitle: Text(
                                            'Last message: ${conversation['lastMessage']}'),
                                        onTap: () {
                                          Get.toNamed(Routes.detailsMessage,
                                              arguments: {
                                                'userId': otherUser['idUser'],
                                              });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const Center(
                            child: Text('Bạn chưa có cuộc trò chuyện nào'),
                          ),

                        // Danh sách người dùng tìm kiếm
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Bắt đầu một trò chuyện mới',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.users.length,
                            itemBuilder: (context, index) {
                              final user = controller.users[index];
                              return ListTile(
                                leading: Obx(() {
                                  if (controller.isLoading.value) {
                                    return const CircularProgressIndicator(); 
                                  } else {
                                    return Avatar(
                                        authorImg: user.avatar ?? '',
                                        radius: 40);
                                  }
                                }),
                                title: Text(user.userName ?? user.email),
                                onTap: () {
                                  Get.toNamed(Routes.detailsMessage,
                                      arguments: {
                                        'userId': user.idUser,
                                      });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
