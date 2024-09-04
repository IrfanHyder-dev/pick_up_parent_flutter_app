import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_parent/models/add_child_model.dart';
import 'package:pickup_parent/models/prediction.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:pickup_parent/src/language/language_keys.dart';

@injectable
class ProfileService with CommonUiService {

  Future autocompletePlaces({required String address}) async{
    print('api hit');
    http.Response response = await http.get('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$address&components=country:PK&key=$googleMapKey'.toUri(),);
    print('response is ${response.body} =====  ${response.statusCode} ');
    return response;

  }

  Future getAddressFromLatLng({required LatLng latLng}) async{
    print('api hit');
    http.Response response = await http.get('https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleMapKey'.toUri(),);
    return response;
  }

  Future getLatLng(String placeId) async{
    try{
      http.Response response = await http.get(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapKey'
            .toUri(),
      );
      print('response is ${response.body}');
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['result'];
        final geometry = result['geometry'];
        return geometry['location'];
      } else {
        return null;
      }
    }catch(e){
      Get.back();
      showCustomWarningTextToast(context: Get.context!, text: wentWrongkey.tr);
      e.debugPrint();
      return null;
    }
  }

  Future updateParentProfile({
required String address,
    required double lat,
    required double lng,
    required String name,
    required String imagePath,
})async{
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    int userId = StaticInfo.userModel!.data.user.id;
    print('user id is ${StaticInfo.userModel!.data.user.id}  ${imagePath}');
    var request = http.MultipartRequest("PUT",'${baseUrl}users/$userId'.toUri(),);
    request.fields["name"] = name!;
    request.fields["location"]= address!;
    request.fields["lat"] = lat.toString();
    request.fields["long"] = lng.toString();
    if(imagePath.isNotEmpty) {
      print('image is not empty');
      request.files
          .add(await http.MultipartFile.fromPath("profile_image", imagePath!));
    }
    request.headers.addAll(headers);
    var response = await request.send();
        return response;
  }

  Future addChild(List<AddChildModel> newChildList)async{
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
      'Content-Type': 'application/json'
    };

     final List<Map<String,dynamic>> newChildDataList = newChildList.map((child) => child.toJson()).toList();
    Map<String,dynamic> body={
      "children": newChildDataList,
    };
    print('child body is ${body}   ${StaticInfo.userModel!.data.user.authToken}');
    print('child list is ${json.encode(newChildDataList)} \n body  is ${json.encode(body)}');

    http.Response response = await http.post('${baseUrl}children'.toUri(),body: json.encode(body),headers: headers);
    print('child response is ${response.body} ');
    return response;
  }

  Future fetchAllChild()async{
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    http.Response response = await http.get('${baseUrl}users/fetch_children'.toUri(),headers: headers);
    print('all child are ${response.body}');
    log(response.body);
    return response;
  }

  Future deleteChild({required int childId})async{
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    http.Response response = await http.delete('${baseUrl}children/$childId'.toUri(),headers: headers);
    print('child deleted ${response.body}');
    log(response.body);
    return response;
  }
}