import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

Future<String> getCurrentLocationUser() async {
  LocationData currentLocation; //= LocationData;
  var location = Location();
  var lang, lat;

  try {
    currentLocation = await location.getLocation();

    // location.onLocationChanged().listen((LocationData currentLocationN) {
    //   currentLocation = currentLocationN;
    //   // print(currentLocation.latitude);
    //   // print(currentLocation.longitude);
    // });
    lang = currentLocation.longitude;
    lat = currentLocation.latitude;
  } catch (e) {
    if (e.code == "PERMISSION_DENIED") {
      var error = "Permission denied";
      // print("location error $e and $error");
    }
    currentLocation = null;

    // print("error occured $e");
  }
  // print("current location: ${currentLocation}");
  // print("current location lang: ${lang}");
  // print("current location lat: ${lat}");
  Coordinates coordinates = Coordinates(lat, lang);
  List<Address> address =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
  // // print(address.length);
  // print(address.first.);
  print(address.first.locality);
  print(address.first.countryName);
  // print(address.first.postalCode);
  print(address.first.subLocality);
  // print(address.first.adminArea);
  // print(address.first.featureName);
  // print(address.first.thoroughfare);
  // print("location done");

  return
      // [
      // address.first.addressLine.toString() +
      //     ", " +
      address.first.locality
      // +
      // ' ' +
      // address.first.subLocality +
      // ' ' +
      // address.first.countryName
      ;
  // lang.toString(),
  // lat.toString()
  // ];
}
