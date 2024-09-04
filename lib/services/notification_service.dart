import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pickup_parent/models/base_model.dart';
import 'package:pickup_parent/models/notification_model.dart';
import 'package:pickup_parent/services/common_ui_service.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:http/http.dart' as http;

@injectable
class NotificationService with CommonUiService {
  Future fetchNotifications() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };

    http.Response response = await http
        .get('${baseUrl}users/user_notifications'.toUri(), headers: headers);
    print('notification is  ${response.statusCode} ${response.body} ');
    return response;
  }

  Future stopNotification({required bool status}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };

    http.Response response = await http.put(
      '${baseUrl}notifications/stop_notification'.toUri(),
      headers: headers,
      body: {
        'user_id': StaticInfo.userModel!.data.user.id.toString(),
        'status': status.toString(),
      },
    );
    print('stop ${response.body}');
    return response;
  }

  Future markNotificationRead({required int id}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };

    http.Response response = await http.put(
        '${baseUrl}notifications/$id/mark_as_read'.toUri(),
        headers: headers);
    print('read ${response.body}  ${response.statusCode}');
    return response;
  }

  Future deleteNotification({required int id}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };

    http.Response response = await http.delete(
        '${baseUrl}notifications/$id/delete_notification'.toUri(),
        headers: headers);
    print('read ${response.body}');
    return response;
  }
}
