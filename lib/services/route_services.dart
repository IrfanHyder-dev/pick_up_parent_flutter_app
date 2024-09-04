import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_parent/models/sent_routes_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';

@injectable
class RoutesServices{
  Future fetchDataForRoute(int driverId)async{

    http.Response response =await http.get('${baseUrl}quotations/parent_child_list?driver_id=$driverId'.toUri(),);
    print('fetch child services');
    log(response.body);
    return response;
  }

  Future childNotGoingToSchool({required int childId,required int quotationId,}) async {

    print('child not going service  ${StaticInfo.userModel?.data.user.authToken}');
    print('${baseUrl}users/$childId/update_child_ride_status?status=not_going&quotation_id=$quotationId');
    try{
      Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    Map<String, dynamic> body = {
      'status': 'not_going',
    };

      http.Response response = await http.put(
          '${baseUrl}users/$childId/update_child_ride_status?status=not_going&quotation_id=$quotationId'.toUri(),
          headers: headers,);
      // http.Response response = await http.put(
      //     'http://147.182.232.146/api/v1/users/26/update_child_ride_status?status=not_going&driver_id=14'.toUri(),
      //     headers: headers,
      //     // body: body
      // );
      return response;
    }
    catch(e){
      // Get.back();
      print('====================== error catch $e');
    }
  }

  Future fetchRoutes({
    required SentRoutesModel sentRoutesModel
  })async{
    Map<String,String>headers = {
      'X-Goog-FieldMask': "*",
    };
    String url = "https://routes.googleapis.com/directions/v2:computeRoutes?key=${StaticInfo.googleApiKey}";
    http.Response response = await http.post(url.toUri(),headers: headers,body: json.encode(sentRoutesModel.toJson()));
    return response;
  }

}