
import 'package:kz_platform/image_classifier.dart';

import 'kz_platform_platform_interface.dart';

class KzPlatform {
  Future<String?> getPlatformVersion() {
    return KzPlatformPlatform.instance.getPlatformVersion();
  }
}
