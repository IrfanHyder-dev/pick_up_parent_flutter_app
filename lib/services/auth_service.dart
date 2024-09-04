import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';


@injectable
class AuthService{
  Future signUpParent({
    required String name,
    required String surName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "surname": surName,
      "contact_no": phoneNumber,
      "email": email,
      "password": password,
      "address": '',
      "fcm_token[]": StaticInfo.fcmToken,
    };
    http.Response response =
        await http.post("${baseUrl}users".toUri(), body: body);
    print('signup auth ${response.statusCode}  ${response.body}');
    return response;
  }

  Future loginParent({
    String? email,
    String? phoneNo,
    String? password,
  }) async {
    print('fcm token is ${StaticInfo.fcmToken}');
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'contact_no': phoneNo,
      "fcm_token[]": StaticInfo.fcmToken,
    };
    http.Response response =
        await http.post('${baseUrl}user/user_login'.toUri(), body: body);
    response.statusCode.debugPrint();
    response.body.debugPrint();
    return response;
  }

  Future resetPassword({required String email}) async {
    http.Response response = await http.get(
      '${baseUrl}users/forgot_password?email=$email'.toUri(),
      //headers: headers
    );
    response.body.debugPrint();
    response.statusCode.debugPrint();
    return response;
  }
  Future otpVerificationCode({required otpCode}) async {
    Map<String, String> headers = {
      //"Content-Type": "application/json",
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };

    print('auth token is ${StaticInfo.userModel!.data.user.authToken}');

    http.Response response = await http.get(
        '${baseUrl}users/verify_otp?otp=$otpCode'.toUri(),
        headers: headers);
    print('otp response is  ${response.body}');
    return response;
  }

  Future logout() async {
    Map<String, String> headers = {
      //"Content-Type": "application/json",
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    http.Response response =
        await http.post('${baseUrl}users/logout'.toUri(), headers: headers);
    print('logout response is ${response.body}');
  }

  Future changePassword(
      {required String oldPassword, required String newPassword}) async {
    Map<String, String> headers = {
      //"Content-Type": "application/json",
      'Authorization': StaticInfo.userModel!.data.user.authToken,
    };
    Map<String, dynamic> body = {
      'current_password': oldPassword,
      'new_password': newPassword,
    };
    http.Response response = await http.post(
        '${baseUrl}users/change_password'.toUri(),
        headers: headers,
        body: body);
    print('logout response is ${response.body}');
    return response;
  }
  
  Future authTokenVerification(String authToken)async{
    Map<String, String> headers = {
      'Authorization': authToken,
    };
    
    http.Response response = await http.get('${baseUrl}users/check_user_token'.toUri(),headers: headers);
    if(response.statusCode == 200){
      var decodedResponse = jsonDecode(response.body);
      if(decodedResponse['success'] == true){
        return true;
      }
      else{
        return false;
      }
    }else{
      return false;
    }
  }
}
