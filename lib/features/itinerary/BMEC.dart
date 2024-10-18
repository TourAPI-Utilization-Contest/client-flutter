///  ___   _ _   ___   ___
/// |___) | | | |___  |
/// |___) |   | |___  |___
///
/// @copyright Copyright (c) 2023 BMEC Technologies. All rights reserved.

import 'dart:math' hide log;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:vector_math/vector_math_64.dart';

/// Conversion factor from pixel size to coordinate degrees.
/// Estimated at [_scalingZoom];
const double _pixelsPerLatLngDeg = 1500000;

/// Map zoom level at which [_pixelsPerLatLngDeg] was estimated.
const double _scalingZoom = 19;

/// Exponent base at which the map scales.
const double _scalingRateBase = 2;

/// Computes the scaling factor based on the [mapZoom].
///
/// The desired [size] is divided by the rate of scaling of the map.
/// See [CameraPosition.zoom] for details.
double computeScale({required int size, required double mapZoom}) =>
    size / _pixelsPerLatLngDeg / pow(_scalingRateBase, mapZoom - _scalingZoom);

/// Special instance of [Circle] that allows for scaling on map zoom.
class CircleMarker extends Circle {
  /// Size of the marker approximately in pixels.
  /// This has not been verified for all devices and/or platforms.
  final int size;

  /// See [CameraPosition.zoom].
  final double mapZoom;

  CircleMarker({
    required super.circleId,
    required this.mapZoom,
    required this.size,
    super.consumeTapEvents,
    super.fillColor,
    super.center,
    super.strokeColor,
    super.strokeWidth,
    super.visible,
    super.zIndex,
    super.onTap,
  }) : super(
            radius: computeScale(
          size: size,
          mapZoom: mapZoom,
        ));

  /// Returns a copy redrawn with an updated [mapZoom].
  copyWithZoom({required double mapZoom}) => CircleMarker(
        circleId: circleId,
        mapZoom: mapZoom,
        size: size,
        consumeTapEvents: consumeTapEvents,
        fillColor: fillColor,
        center: center,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        visible: visible,
        zIndex: zIndex,
        onTap: onTap,
      );
}

class PolygonMarkerIcon {
  /// Unit square icon.
  static final List<Vector2> squareIcon = [
    Vector2(-0.5, -0.5),
    Vector2(-0.5, 0.5),
    Vector2(0.5, 0.5),
    Vector2(0.5, -0.5),
  ];

  /// Material Design Icon `navigation`.
  /// See https://petershaggynoble.github.io/MDI-Sandbox/?icon=navigation.
  static final List<Vector2> navigationIcon = [
    Vector2(0, -0.5),
    Vector2(0.395, 0.463),
    Vector2(0.357, 0.500),
    Vector2(0.000, 0.342),
    Vector2(-0.358, 0.500),
    Vector2(-0.395, 0.463),
  ];
}

/// Special instance of [Polygon] that acts as a [Marker] and allows for scaling
/// and rotation on map zoom. Used due to marker anchor and rotation having no
/// effect on web.
class PolygonMarker extends Polygon {
  /// List of (x, y) coordinates that define the vertices of the
  /// **unit** polygon. (0, 0) defines the centroid of rotation and scale.
  /// FEATURE add support for an anchor.
  final List<Vector2> iconPoints;

  /// Size of the marker approximately in pixels.
  /// This has not been verified for all devices and/or platforms.
  final int size;

  /// See [CameraPosition.zoom].
  final double mapZoom;

  /// Geographical location of the marker.
  final LatLng position;

  /// Rotation of the marker image in degrees clockwise from the [anchor] point.
  final double rotation;

  /// Pseudo constructor for this mixin.
  PolygonMarker({
    required this.iconPoints,
    required this.size,
    required this.mapZoom,
    required this.position,
    required this.rotation,
    required super.polygonId,
    super.consumeTapEvents,
    super.fillColor,
    super.geodesic,
    super.strokeColor,
    super.strokeWidth,
    super.visible,
    super.zIndex,
    super.onTap,
  }) : super(points: []) {
    assert(
        iconPoints
                .expand((iconPoint) => [iconPoint.x.abs(), iconPoint.y.abs()])
                .reduce(max) <=
            0.5,
        "iconPoints should be a unit icon i.e. lie inside a unit square centered at (0,0)");
    points
      ..clear()
      ..addAll(_transformPoints().map((point) => LatLng(point.y, point.x)));
  }

  /// Sets [points] to the rotated transform of [_scaledPoints] about
  /// [position].
  Iterable<Vector2> _transformPoints() =>
      iconPoints.map((point) => _transformPoint(
            point: point,
            position: Vector2(position.longitude, position.latitude),
            rotationDegrees: rotation,
            scale: computeScale(size: size, mapZoom: mapZoom),
          ));

  /// Returns a copy redrawn with an updated [mapZoom], [position] and/or
  /// [rotation]
  Polygon copyWithTransform({
    double? mapZoom,
    LatLng? position,
    double? rotation,
  }) =>
      PolygonMarker(
        iconPoints: iconPoints,
        size: size,
        mapZoom: mapZoom ?? this.mapZoom,
        position: position ?? this.position,
        rotation: rotation ?? this.rotation,
        polygonId: polygonId,
        consumeTapEvents: consumeTapEvents,
        fillColor: fillColor,
        geodesic: geodesic,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        visible: visible,
        zIndex: zIndex,
        onTap: onTap,
      );

  /// Rotates a [point] by [rotationDegrees], scales by [scale] and offsets
  /// to [position].
  static Vector2 _transformPoint({
    required Vector2 point,
    required Vector2 position,
    required double rotationDegrees,
    required double scale,
  }) =>
      (Matrix4.translationValues(position.x, position.y, 0)
            ..rotateZ(radians((-1 * rotationDegrees) + 180)))
          .transform3(Vector3(point.x, point.y, 0).scaled(scale))
          .xy;
}
