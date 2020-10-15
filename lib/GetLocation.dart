import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GetLocation{
  double latitude;
  double longitude;
  String city;

  //get current location
  Future<void> getCurrentLocation() async{
    try {
      Position position = await getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;

      city = await getCityName(position.latitude, position.longitude);
    }
    catch(e){
      print(e);
    }
  }

  //get city name
  Future<String> getCityName(double lat, double lon) async{
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    return placemark[0].locality;
  }
}