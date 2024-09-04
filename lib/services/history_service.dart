import 'package:injectable/injectable.dart';
import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/app/static_info.dart';
import 'package:http/http.dart' as http;

@injectable
class HistoryService{

  Future userPaymentHistory()async{
    Map<String,String> headers={
      'Authorization': StaticInfo.userModel?.data.user.authToken ?? '',
    };

    http.Response response =await http.get('${baseUrl}users/payment_history'.toUri(),headers: headers);
    print('user payment history ${response.body}');
    return response;
  }

  Future userRideHistory()async{
    Map<String,String> headers = {
      'Authorization': StaticInfo.userModel?.data.user.authToken ?? '',
    };

    http.Response response = await http.get('${baseUrl}users/ride_histories'.toUri(),headers: headers);
    print('user ride history ${response.body}');
    return response;
  }
}