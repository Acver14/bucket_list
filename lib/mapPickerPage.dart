import 'package:geocoder/geocoder.dart'; //import geocoder to get address line from coordinates
import 'package:geolocator/geolocator.dart';
import 'package:map_pin_picker/map_pin_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MapPickerPage extends StatefulWidget {
  Position currentPosition;
  MapPickerPage({Key key, this.title, @required this.currentPosition}) : super(key: key);
  final String title;

  @override
  MapPickerPageState createState() => MapPickerPageState();
}

class MapPickerPageState extends State<MapPickerPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition;

  Address address;

  var textController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraPosition = CameraPosition(
        target: LatLng(
      widget.currentPosition.latitude,
      widget.currentPosition.longitude*(-1)
    ),
    zoom: 15);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapPicker(
              // pass icon widget
              iconWidget: Icon(
                Icons.location_pin,
                size: 50,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                zoomControlsEnabled: true,
                // hide location button
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                //  camera position
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  mapPickerController.mapMoving();
                },
                onCameraMove: (cameraPosition) {
                  this.cameraPosition = cameraPosition;
                },
                zoomGesturesEnabled: true,
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving();
                  //get address name from camera position
                  List<Address> addresses = await Geocoder.local
                      .findAddressesFromCoordinates(Coordinates(
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude));
                  // update the ui with the address
                  textController.text = '${addresses.first?.addressLine ?? ''}';
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Colors.black,
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero, border: InputBorder.none),
            controller: textController,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          // icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }

}
