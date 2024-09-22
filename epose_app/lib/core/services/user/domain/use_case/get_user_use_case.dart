import 'dart:convert';

import '../../../../configs/prefs_constants.dart';
import '../../../../data/pref/prefs';
import '../../model/user_model.dart';


class GetuserUseCase {
  final Prefs _prefs;

  GetuserUseCase(this._prefs);

  Future<UserModel?> getUser() async {
    final tokenJson = await _prefs.getObject(PrefsConstants.user);
    if (tokenJson.isEmpty) {
      return null;
    }
    return UserModel.fromJson(json.decode(tokenJson));
  }
}
