
import '../../../../configs/prefs_constants.dart';
import '../../../../data/pref/prefs';
import '../../model/auth_model.dart';
import '../../model/user_model.dart';

class SaveUserUseCase {
  final Prefs _prefs;

  SaveUserUseCase(this._prefs);

  Future saveUser(UserModel user) async {
    await _prefs.set(PrefsConstants.user, user);
    
  }

  Future saveToken(AuthenticationModel auth) async {
    await _prefs.set(PrefsConstants.auth, auth);
  }
}
