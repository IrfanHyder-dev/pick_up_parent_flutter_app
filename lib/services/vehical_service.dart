import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';
import 'package:pickup_parent/models/available_drivers_model.dart';
import 'package:pickup_parent/models/booking_response_model.dart';
import 'package:pickup_parent/models/payment_completed_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';

@injectable
class VehicleService {

  Future fetchDriver(List<int> ids) async {
    print('vehicle service');
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    List<http.MultipartFile> selectedChildId = [];
    for (int item in ids) {
      var result =
          await http.MultipartFile.fromString('child_id[]', item.toString());
      selectedChildId.add(result);
      print('ids are $item');
    }
    http.MultipartRequest request =
        http.MultipartRequest("GET", '${baseUrl}users/find_drivers'.toUri());
    request.files.addAll(selectedChildId);
    request.headers.addAll(headers);
    var response = await request.send();
    // var responseData = await response.stream.bytesToString();
    // if (response.statusCode == 200) {
    //   var result = json.decode(responseData);
    //   print('veh is ${result}');
    //   AvailableDriversModel availableDriversModel =
    //       AvailableDriversModel.fromJson(result);
    //   return availableDriversModel;
    // } else {
    //   return null;
    // }
    return response;
  }

  Future createBooking({
    required List<int> ids,
  }) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    List<http.MultipartFile> selectedChildId = [];
    for (int item in ids) {
      var result =
          await http.MultipartFile.fromString('child_ids[]', item.toString());
      selectedChildId.add(result);
      print('ids are $item');
    }

    http.MultipartRequest request =
        http.MultipartRequest("POST", "${baseUrl}quotations".toUri());
    request.fields['user_id'] = StaticInfo.userModel!.data.user.id.toString();
    request.fields['driver_id'] = StaticInfo.selectedDriver!.id.toString();
    request.fields['amount'] = StaticInfo.selectedDriver!.fareAmount.toString();
    request.fields['status'] = 'pending';
    request.files.addAll(selectedChildId);
    request.headers.addAll(headers);

    var response = await request.send();
    // var responseData = await response.stream.bytesToString();
    //print('booking is  ${responseData}');
    return response;
  }

  Future fetchAllSubscriptions() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    print('----------------------- ${StaticInfo.userModel!.data.user.authToken}');

    http.Response response =
        await http.get('${baseUrl}quotations'.toUri(), headers: headers);
    print('subscriptions are ${response.body}');

    return response;
  }

  Future cancelRequest({required int quotationId}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    print('----------------------- ${StaticInfo.userModel!.data.user.authToken}');

    http.Response response =
    await http.delete('${baseUrl}quotations/$quotationId/cancle_quotation'.toUri(), headers: headers);
    print('subscriptions are ${response.body}');

    return response;
  }

  Future payNow({
    required int id,
  }) async {
    print('booking id is $id');
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    Map<String, dynamic> body = {
      "quotation_id" : id.toString(),
      "payment_type": "easypaisa",
    };

    http.Response response = await http.post('${baseUrl}payments'.toUri(),
        body: body, headers: headers);
    print('pay now is ${response.body}');

    return response;
  }
}
