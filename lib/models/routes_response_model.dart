import 'dart:convert';

RoutesResponseModel routesResponseModelFromJson(String str) =>
    RoutesResponseModel.fromJson(json.decode(str));

String routesResponseModelToJson(RoutesResponseModel data) =>
    json.encode(data.toJson());

class RoutesResponseModel {
  String? encodedPolyline;
  List<int>? optimizedIntermediateWaypointIndex;
  LocalizedValues? localizedValues;

  RoutesResponseModel({
    this.encodedPolyline,
    this.optimizedIntermediateWaypointIndex,
    this.localizedValues,
  });

  factory RoutesResponseModel.fromJson(Map<String, dynamic> json) =>
      RoutesResponseModel(
        encodedPolyline: json["encodedPolyline"],
        optimizedIntermediateWaypointIndex:
            json["optimizedIntermediateWaypointIndex"] == null
                ? []
                : List<int>.from(
                    json["optimizedIntermediateWaypointIndex"]!.map((x) => x)),
        localizedValues: json["localizedValues"] == null
            ? null
            : LocalizedValues.fromJson(json["localizedValues"]),
      );

  Map<String, dynamic> toJson() => {
        "encodedPolyline": encodedPolyline,
        "optimizedIntermediateWaypointIndex":
            optimizedIntermediateWaypointIndex == null
                ? []
                : List<dynamic>.from(
                    optimizedIntermediateWaypointIndex!.map((x) => x)),
        "localizedValues": localizedValues?.toJson(),
      };
}

class LocalizedValues {
  Distance? distance;
  Distance? duration;
  Distance? staticDuration;

  LocalizedValues({
    this.distance,
    this.duration,
    this.staticDuration,
  });

  factory LocalizedValues.fromJson(Map<String, dynamic> json) =>
      LocalizedValues(
        distance: json["distance"] == null
            ? null
            : Distance.fromJson(json["distance"]),
        duration: json["duration"] == null
            ? null
            : Distance.fromJson(json["duration"]),
        staticDuration: json["staticDuration"] == null
            ? null
            : Distance.fromJson(json["staticDuration"]),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance?.toJson(),
        "duration": duration?.toJson(),
        "staticDuration": staticDuration?.toJson(),
      };
}

class Distance {
  String? text;

  Distance({
    this.text,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}
