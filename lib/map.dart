import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocode/geocode.dart';
import 'package:latlong2/latlong.dart';

class MapApp extends StatefulWidget {
  const MapApp({
    super.key,
  });

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  @override
  LatLng point = LatLng(-38, -57.55);
  var location;
  GeoCode geoCode = new GeoCode();
  MapController mapController = new MapController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mapa Berreta")),
        body: Stack(
            //
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: (x, p) {
                    updateLocation();
                    setState(() {
                      point = p;
                      log("papa");
                    });
                  },
                  center: point,
                  zoom: 10.0,
                ),
                children: [
                  TileLayer(
                      keepBuffer: 100,
                      //maxZoom: 5, better to controlled it from an upper part
                      // it will not show image when you zoom greater than the value
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayer(markers: [
                    Marker(
                        width: 50,
                        height: 50,
                        point: point,
                        builder: (ctx) => Icon(
                              Icons.location_on,
                              size: 40,
                              //color: Colors.red,
                            ))
                  ]),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.map),
                            hintText: "Search for Location",
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          onSubmitted: (loc) {
                            var coordinates =
                                geoCode.forwardGeocoding(address: loc);
                            coordinates.then((coordinates) {
                              print("Longitude: ${coordinates.longitude}");
                              print("Latitude: ${coordinates.latitude}");
                              point.latitude = coordinates.latitude as double;
                              point.longitude = coordinates.longitude as double;
                              updateLocation();
                              centerMap();
                            });
                            setState(() {
                              location = coordinates;
                            });
                          },
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                              "${location is Future ? "putoElQueLee" : location}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ]),
              )
            ]));
  }

  void updateLocation() {
    location = geoCode.reverseGeocoding(
        latitude: point.latitude, longitude: point.longitude);
    location.then((value) => {
          setState(() {
            location = value;
            log("papa");
          })
        });
  }

  void centerMap() {
    setState(() {
      mapController.move(point, 15);
    });
  }
}
