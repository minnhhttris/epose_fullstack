import 'package:epose_app/core/configs/prefs_constants.dart';
import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/maps/location/models/place_map.dart';

class SaveLoactionCase {
  final Prefs _prefs;

  SaveLoactionCase(this._prefs);
  Future saveLocation(PlaceMap placeMap) async {
    _prefs.set(PrefsConstants.location, placeMap);
  }
}
