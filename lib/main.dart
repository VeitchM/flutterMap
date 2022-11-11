import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocode/geocode.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.yellow,
      ),
      home: const MapApp(),
    );
  }
}

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
    return Stack(
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
                    builder: (ctx) =>
                        Icon(Icons.location_on, size: 40, color: Colors.red))
              ]),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24),
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
                      onSubmitted: (loc) async {
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
        ]);
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
