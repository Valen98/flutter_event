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

  @override
  void initState() {
    super.initState();
    _loadPlaceDetails();
  }

  void _loadPlaceDetails() async {
    final placeDetails =
        await _eventMapService.fetchPlaceDetails(widget.addressID);
    final location = placeDetails['geometry']['location'];
    LatLng position = LatLng(location['lat'], location['lng']);

    setState(() {
      _center = position;
      _markers.add(Marker(
          markerId: const MarkerId('place_id'),
          position: position,
          infoWindow: const InfoWindow(title: 'Address of Event')));
    });
  }

  @override
  Widget build(BuildContext context) {
    //Right now its a bug going back and forth between different pages. Bug with widget.addressID.
    return Center(
      child: SizedBox(
        height: 600,
        width: 400,
        child: _center == null
            ? const Center(child: CircularProgressIndicator())
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
      ),
    );
  }
}
