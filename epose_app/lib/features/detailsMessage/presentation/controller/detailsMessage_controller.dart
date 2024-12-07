import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';

class DetailsMessageController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  DetailsMessageController(this._getuserUseCase);

  var messages = [].obs; // Danh sách tin nhắn
  var isLoading = false.obs;
  var selectedUserId = ''.obs;
  var currentUserId = ''.obs;
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    selectedUserId.value = Get.arguments['userId']; // Lấy userId từ arguments
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    try {
      currentUserId.value = (await _getuserUseCase.getUser())?.idUser ?? '';
      setupSocket();
      await getMessages();
    } catch (e) {
      print('Error initializing: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMessages() async {
    try {
      final response = await apiService.getData(
        'messages/user/${selectedUserId.value}',
        accessToken: (await _getuserUseCase.getToken())?.metadata ?? '',
      );
      messages.value = response['data'] ?? [];
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> setupSocket() async {
    socket = IO.io(
      apiServiceURL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({
            "Authorization": "Bearer ${(await _getuserUseCase.getToken())?.metadata ?? ''}"
          })
          .build(),
    );

    socket.onConnect((_) => print('Socket connected'));

    socket.on("receiveMessage", (data) {
      if (data['senderId'] == selectedUserId.value ||
          data['receiverId'] == currentUserId.value) {
        messages.add(data);
      }
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
  }

  void sendMessage(String content) {
    if (content.isEmpty || selectedUserId.isEmpty) return;

    final messageData = {
      "senderId": currentUserId.value,
      "receiverId": selectedUserId.value,
      "message": content,
    };

    socket.emit("sendMessage", messageData);

    messages.add({
      "senderId": currentUserId.value,
      "receiverId": selectedUserId.value,
      "message": content,
      "sendAt": DateTime.now().toIso8601String(),
    });
  }
}
