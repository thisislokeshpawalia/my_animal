import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'address_model.dart';

class LocationService {
  Future<AddressModel> getCurrentLocationAddress() async {
    /// Check GPS Service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Please enable location services.");
    }

    /// Check Permission
    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied.");
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      throw Exception(
        "Location permission permanently denied.",
      );
    }

    /// Current Coordinates
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    /// Convert to Address
    List<Placemark> places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (places.isEmpty) {
      throw Exception("Unable to fetch address.");
    }

    final place = places.first;

    return AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "Current Location",
      fullName: "",
      phone: "",
      addressLine1: place.name ?? "",
      addressLine2: place.street ?? "",
      city: place.locality ?? "",
      state: place.administrativeArea ?? "",
      pincode: place.postalCode ?? "",
      isDefault: true,
    );
  }
}