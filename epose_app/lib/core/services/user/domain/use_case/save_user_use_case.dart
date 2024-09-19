
import '../../../../configs/prefs_constants.dart';
import '../../../../data/pref/prefs';
import '../../model/user_model.dart';

class SaveUserUseCase {
  final Prefs _prefs;

  SaveUserUseCase(this._prefs);

  Future saveUser(UserModel user) async {
    _prefs.set(PrefsConstants.user, user);
  }
}
