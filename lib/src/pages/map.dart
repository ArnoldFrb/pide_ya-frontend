import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'map/directions_provider.dart';

class MapPage extends StatefulWidget {

  final String origen;
  final String destino;

  MapPage(
    this.origen,
    this.destino,
  );

  @override
  _MapPageState createState() => _MapPageState();

  static const String ROUTE = "/map";

}

class _MapPageState extends State<MapPage> {

  final LatLng position = LatLng(10.46314, -73.25322);
  final LatLng fromPoint = LatLng(10.471212, -73.271527);
  final LatLng toPoint = LatLng(10.472842, -73.268060);

  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    if (widget.origen.isEmpty && widget.destino.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Mapa"),
          backgroundColor: cPideYaAmber400,
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 13,
          ),
        ),
        resizeToAvoidBottomInset: false,
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: Text("Ruta"),
          backgroundColor: cPideYaAmber400,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: cPideYaAmber400,
          child: Icon(Icons.zoom_out_map),
          onPressed: _centerView,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
        body:ChangeNotifierProvider(
          create: (_) => new DirectionProvider(),
          child: Builder(
            builder : (context) => Consumer<DirectionProvider>(
              builder:(BuildContext context, DirectionProvider api, Widget child) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: fromPoint,
                    zoom: 12,
                  ),
                  markers: _createMarkers(),
                  polylines: api.currentRoute,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                );
              },
            )
          )
        ),
        resizeToAvoidBottomInset: false,
      );
    }
  }

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(
      Marker(
        markerId: MarkerId("fromPoint"),
        position: fromPoint,
        infoWindow: InfoWindow(title: "Origen"),
      ),
    );
    tmp.add(
      Marker(
        markerId: MarkerId("toPoint"),
        position: toPoint,
        infoWindow: InfoWindow(title: "Destino"),
      ),
    );
    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _centerView();
  }

  _centerView() async {
    var api = Provider.of<DirectionProvider>(context);

    await _mapController.getVisibleRegion();

    print("buscando direcciones");
    await api.findDirections(fromPoint, toPoint);

    var left = min(fromPoint.latitude, toPoint.latitude);
    var right = max(fromPoint.latitude, toPoint.latitude);
    var top = max(fromPoint.longitude, toPoint.longitude);
    var bottom = min(fromPoint.longitude,toPoint.longitude);

    api.currentRoute.first.points.forEach((point) {
      left = min(left, point.latitude);
      right = max(right, point.latitude);
      top = max(top, point.longitude);
      bottom = min(bottom, point.longitude);
    });

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _mapController.animateCamera(cameraUpdate);
  }
}