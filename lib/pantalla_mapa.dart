// ignore_for_file: use_key_in_widget_constructors, prefer_collection_literals

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// ignore: camel_case_types
class pantalla_mapa extends StatefulWidget {
  @override
  _EstadoMapa createState() => _EstadoMapa();
}

// Markers to show points on the map
Map<MarkerId, Marker> markers = {};
PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

const LatLng fromPoint = LatLng(19.6620115, -101.1974723);
const LatLng toPoint = LatLng(19.722130, -101.185992);

class _EstadoMapa extends State<pantalla_mapa> {
  late GoogleMapController _mapController;

  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    /// add origin marker origin marker
    _addMarker(
      fromPoint,
      "Origen",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      toPoint,
      "Destino",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _getPolyline();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualización de Ruta',
      home: Scaffold(
        appBar: AppBar(
          title: Text('RUTA DE ENVIO',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.grey[50], letterSpacing: .5),
              )),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              const CameraPosition(target: fromPoint, zoom: 12),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          polylines: Set<Polyline>.of(polylines.values),
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _mapController = controller;
            _centerView();
          },
        ),
      ),
    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      ">API KEY",
      PointLatLng(fromPoint.latitude, fromPoint.longitude),
      PointLatLng(toPoint.latitude, toPoint.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _centerView() async {
    var izquierda = min(fromPoint.latitude, toPoint.latitude);
    var derecha = max(fromPoint.latitude, toPoint.latitude);
    var arriba = max(fromPoint.longitude, toPoint.longitude);
    var abajo = min(fromPoint.longitude, toPoint.longitude);

    // ignore: non_constant_identifier_names
    var Bounds = LatLngBounds(
        southwest: LatLng(izquierda, abajo),
        northeast: LatLng(derecha, arriba));
    var cameraUpdate = CameraUpdate.newLatLngBounds(Bounds, 50);
    _mapController.animateCamera(cameraUpdate);
  }
}
