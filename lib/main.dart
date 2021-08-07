import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map/location.dart';
import "package:latlong2/latlong.dart";
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String address = '';
  Future<void> _getAddrress(double latitude, double longitude) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(latitude, longitude);
    print(newPlace[0]);
    Placemark placeMark = newPlace[0];
    String? name = placeMark.name;

    String? locality = placeMark.locality;

    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    address = "${name}, ${locality},${postalCode}, ${country}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: acquireCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLng?> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print(snapshot.data!.latitude);
            return FlutterMap(
              options: MapOptions(
                center:
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "xxx",
                    additionalOptions: {
                      'accessToken':
                          'xxx',
                      'id': 'mapbox.mapbox-streets-v8',
                    }),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 120.0,
                      height: 120.0,
                      point: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      builder: (ctx) => Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          onPressed: () async {
                            await _getAddrress(snapshot.data!.latitude,
                                snapshot.data!.longitude);
                            showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text('Address'),
                                          subtitle: Text(address),
                                        ),
                                        RaisedButton(
                                          onPressed: null,
                                          child: Text(
                                            'Confirm',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
//IN Raised Button we will call Navigation.pop(context) to store the address and navigate to other location
