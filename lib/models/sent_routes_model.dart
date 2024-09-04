class SentRoutesModel {
  Origin? origin;
  Origin? destination;
  List<Origin>? intermediates;
  String? travelMode;
  String? routingPreference;
  String? polylineQuality;
  String? polylineEncoding;
  String? computeAlternativeRoutes;
  String? optimizeWaypointOrder;
  RouteModifiers? routeModifiers;
  String? languageCode;
  String? units;

  SentRoutesModel(
      {this.origin,
        this.destination,
        this.intermediates,
        this.travelMode = "DRIVE",
        this.routingPreference = "TRAFFIC_AWARE",
        this.polylineQuality = "HIGH_QUALITY",
        this.polylineEncoding = "ENCODED_POLYLINE",
        this.computeAlternativeRoutes = "FALSE",
        this.routeModifiers,
        this.languageCode = "en-US",
        this.optimizeWaypointOrder = "TRUE",
        this.units = "IMPERIAL"});

  SentRoutesModel.fromJson(Map<String, dynamic> json) {
    origin =
    json['origin'] != null ? new Origin.fromJson(json['origin']) : null;
    destination = json['destination'] != null
        ? new Origin.fromJson(json['destination'])
        : null;
    if (json['intermediates'] != null) {
      intermediates = <Origin>[];
      json['intermediates'].forEach((v) {
        intermediates!.add(new Origin.fromJson(v));
      });
    }
    travelMode = json['travelMode'];
    routingPreference = json['routingPreference'];
    polylineQuality = json['polylineQuality'];
    polylineEncoding = json['polylineEncoding'];
    computeAlternativeRoutes = json['computeAlternativeRoutes'];
    optimizeWaypointOrder = json['optimizeWaypointOrder'];
    routeModifiers = json['routeModifiers'] != null
        ? new RouteModifiers.fromJson(json['routeModifiers'])
        : null;
    languageCode = json['languageCode'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.origin != null) {
      data['origin'] = this.origin!.toJson();
    }
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    if (this.intermediates != null) {
      data['intermediates'] =
          this.intermediates!.map((v) => v.toJson()).toList();
    }
    data['travelMode'] = this.travelMode;
    data['routingPreference'] = this.routingPreference;
    data['polylineQuality'] = this.polylineQuality;
    data['polylineEncoding'] = this.polylineEncoding;
    data['optimizeWaypointOrder'] = this.optimizeWaypointOrder;
    data['computeAlternativeRoutes'] = this.computeAlternativeRoutes;
    if (this.routeModifiers != null) {
      data['routeModifiers'] = this.routeModifiers!.toJson();
    }
    data['languageCode'] = this.languageCode;
    data['units'] = this.units;
    return data;
  }
}

class Origin {
  Location? location;

  Origin({this.location});

  Origin.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Location {
  LatLng? latLng;

  Location({this.latLng});

  Location.fromJson(Map<String, dynamic> json) {
    latLng =
    json['latLng'] != null ? new LatLng.fromJson(json['latLng']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.latLng != null) {
      data['latLng'] = this.latLng!.toJson();
    }
    return data;
  }
}

class LatLng {
  double? latitude;
  double? longitude;

  LatLng({this.latitude, this.longitude});

  LatLng.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class RouteModifiers {
  bool? avoidTolls;
  bool? avoidHighways;
  bool? avoidFerries;

  RouteModifiers({this.avoidTolls = false, this.avoidHighways = false, this.avoidFerries = false});

  RouteModifiers.fromJson(Map<String, dynamic> json) {
    avoidTolls = json['avoidTolls'];
    avoidHighways = json['avoidHighways'];
    avoidFerries = json['avoidFerries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avoidTolls'] = this.avoidTolls;
    data['avoidHighways'] = this.avoidHighways;
    data['avoidFerries'] = this.avoidFerries;
    return data;
  }
}
