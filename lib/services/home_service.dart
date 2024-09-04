import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_parent/models/all_child_model.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';

@injectable
class HomeService {
  Future fetchAllChild() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    http.Response response = await http
        .get('${baseUrl}users/fetch_children'.toUri(), headers: headers);
   return response;
  }
}
