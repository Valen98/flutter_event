import 'package:event/services/event/event_map_service.dart';
import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventMap extends StatefulWidget {
  final String addressID;
  const EventMap({super.key, required this.addressID});

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  final EventMapService _eventMapService = EventMapService();
  late GoogleMapController mapController;
  LatLng? _center;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _loadPlaceDetails();
  }

  void _loadPlaceDetails() async {
    try {
      final placeDetails =
          await _eventMapService.fetchPlaceDetails(widget.addressID);
      final location = placeDetails['geometry']['location'];
      LatLng position = LatLng(location['lat'], location['lng']);
      setState(() {
        _center = position;
        _markers.add(
          Marker(
            markerId: const MarkerId('place_id'),
            position: position,
            infoWindow: const InfoWindow(
              title: 'Selected Location',
            ),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Right now its a bug going back and forth between different pages. Bug with widget.addressID.
    return Center(
        child: SizedBox(
      height: 600.0, // Set the height of the box
      width: 400.0, // Set the width of the box
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _center!,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                ),
    ));
  }
}
