
import 'package:connectivity/connectivity.dart';

Future<bool> connection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("connectionResult M = $connectivityResult");

    return Future.value(true);
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("connectionResult W= $connectivityResult");

    return Future.value(true);
  } else {
    print("connectionResult = $connectivityResult");

    return Future.value(false);
  }
}
