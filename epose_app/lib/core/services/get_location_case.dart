import 'dart:convert';

import 'package:epose_app/core/configs/prefs_constants.dart';
import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/features/maps/location/models/place_map.dart';

class GetLocationCase {
  final Prefs _prefs;

  GetLocationCase(this._prefs);

  Future<PlaceMap?> getLocation() async {
    final tokenJson = await _prefs.getObject(PrefsConstants.location);
    if (tokenJson.isEmpty) {
      return null;
    }
    
    return PlaceMap.fromJson(json.decode(tokenJson));
  }
  
}
