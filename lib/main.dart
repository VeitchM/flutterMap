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

  Widget build(BuildContext context) {
    return Stack(
        //
        children: [
          FlutterMap(
            options: MapOptions(
              onTap: (x, p) async {
                setState(() {
                  point = p;
                  log("papa");
                });

                location = await geoCode.reverseGeocoding(
                    latitude: point.latitude, longitude: point.longitude);
                print(location);
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
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Puto el que lee",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ]),
          )
        ]);
  }
}
