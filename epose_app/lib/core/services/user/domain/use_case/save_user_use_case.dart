
import 'dart:convert';

import '../../../../configs/prefs_constants.dart';
import '../../../../data/pref/prefs';
import '../../model/auth_model.dart';
import '../../model/user_model.dart';

class SaveUserUseCase {
  final Prefs _prefs;

  SaveUserUseCase(this._prefs);

  Future<void> saveUser(UserModel? user) async {
    if (user != null) {
      try {
        final userJson = jsonEncode(user.toJson());
        await _prefs.set(PrefsConstants.user, userJson);
      } catch (e) {
        // Handle the error, maybe log it or show an alert
        print('Failed to save user: $e');
      }
    }
  }

  Future<void> saveToken(AuthenticationModel model) async {
    try {
      final authentication = jsonEncode(model.toJson());
      await _prefs.set(PrefsConstants.userToken, authentication);
    } catch (e) {
      // Handle the error, maybe log it or show an alert
      print('Failed to save user: $e');
    }
  }
}
