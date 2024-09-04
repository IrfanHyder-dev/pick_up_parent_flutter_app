import 'package:connectivity_plus/connectivity_plus.dart';

const String url = 'http://147.182.232.146:3000/';
// const String url = 'https://b3d6-182-185-226-52.ngrok-free.app';
const String baseUrl = '$url/api/v1/';
const String userExpired = "Not Authorized";
const String googleMapKey = 'AIzaSyALtywJGaRIoFBo1sv3C6NJRmZ80_diz3U';

const double hMargin = 20;
const double vMargin = 12;
const double margin38 = 38;

const double margin18 = 18;
const double margin16 = 16;

const double logoH = 27;
const double logoW = 100;

List<int> successCodes = [
  200,
  201,
  202,
  204,
];

Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
