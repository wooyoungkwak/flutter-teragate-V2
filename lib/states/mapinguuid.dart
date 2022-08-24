import 'package:get/get.dart';

import '../utils/Log_util.dart';

class Controller extends GetxController {
  var count = 0.obs;
  var count2 = "0".obs;
  var count3 = <String>[].obs;
  var count4 = <String, String>{}.obs;

  get mapUUID => null;
  increment() {
    Log.debug("변경");
    count++;
    count2("funt");
    count4['data'] = "TESTegregreg";
  }
}
