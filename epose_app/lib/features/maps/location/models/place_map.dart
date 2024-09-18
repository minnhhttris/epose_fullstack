class PlaceMap {
  final int? placeId;
  final String? licence;
  final String? osmType;
  final int? osmId;
  double? lat;
  double? lon;
  final String? className;
  final String? type;
  final int? placeRank;
  final double? importance;
  final String? addressType;
  final String? name;
  String? displayName;
  final List<double>? boundingBox;

  PlaceMap({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.className,
    this.type,
    this.placeRank,
    this.importance,
    this.addressType,
    this.name,
    this.displayName,
    this.boundingBox,
  });

  // From JSON to Object
  factory PlaceMap.fromJson(Map<String, dynamic> json) {
    return PlaceMap(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      lat: json['lat'] != null ? double.tryParse(json['lat']) : null,
      lon: json['lon'] != null ? double.tryParse(json['lon']) : null,
      className: json['class'],
      type: json['type'],
      placeRank: json['place_rank'],
      importance: json['importance']?.toDouble(),
      addressType: json['addresstype'],
      name: json['name'],
      displayName: json['display_name'],
      boundingBox: json['boundingbox'] != null
          ? (json['boundingbox'] as List).map((item) => double.tryParse(item) ?? 0.0).toList()
          : null,
    );
  }
  // From Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'licence': licence,
      'osm_type': osmType,
      'osm_id': osmId,
      'lat': lat?.toString(),
      'lon': lon?.toString(),
      'class': className,
      'type': type,
      'place_rank': placeRank,
      'importance': importance,
      'addresstype': addressType,
      'name': name,
      'display_name': displayName,
      'boundingbox': boundingBox?.map((item) => item.toString()).toList(),
    };
  }

  bool allow(){
    return (displayName!=null && lat !=null && lon!= null);
  }

}
