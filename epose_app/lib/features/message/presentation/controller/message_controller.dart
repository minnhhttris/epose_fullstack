import 'package:get/get.dart';
import '../../../../api.config.dart';
import '../../../../core/services/api.service.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
import '../../../../core/services/user/model/user_model.dart';

class MessageController extends GetxController {
  final apiService = ApiService(apiServiceURL);
  final GetuserUseCase _getuserUseCase;

  MessageController(this._getuserUseCase);

  var user = Rx<UserModel?>(null);
  var authToken = ''.obs;
  var conversations = [].obs; 
  var users = <UserModel>[].obs; 
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading.value = true;
    try {
      user.value = await _getuserUseCase.getUser();
      authToken.value = (await _getuserUseCase.getToken())?.metadata ?? '';
      await getConversations();
      await getAllUsers();
    } catch (e) {
      print('Error initializing: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getConversations() async {
    try {
      final response = await apiService.getData(
        'messages/conversations/',
        accessToken: authToken.value,
      );
      conversations.value = response['data'] ?? [];
    } catch (e) {
      print('Error fetching conversations: $e');
    }
  }

  Future<void> getAllUsers() async {
    try {
      final response = await apiService.getData(
        'users/getAllUsers',
        accessToken: authToken.value,
      );

      // Parse danh sách người dùng từ API
      final fetchedUsers =
          (response['data'] as List).map((e) => UserModel.fromJson(e)).toList();

      // Lọc danh sách người dùng: loại trừ người dùng hiện tại và admin
      users.value = fetchedUsers.where((u) {
        final isCurrentUser = u.idUser == user.value?.idUser;
        final isAdmin =
            u.role.contains('admin'); 
        return !isCurrentUser && !isAdmin;
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

}
