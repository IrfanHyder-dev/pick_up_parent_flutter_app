import 'package:flutter/material.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailViewModel extends BaseViewModel{

  void phoneOnTap()async{
    print('call call');
    Uri phone = Uri.parse('tel:${StaticInfo.selectedDriver!.contactNumber}');
    if(await launchUrl(phone)){

    }else{

    }
  }

  void smsOnTap()async{
    print('call call');
    Uri sms = Uri.parse('sms:${StaticInfo.selectedDriver!.contactNumber}');
    if(await launchUrl(sms)){

    }else{

    }
  }
}