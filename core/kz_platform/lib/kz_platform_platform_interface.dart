import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kz_platform_method_channel.dart';

abstract class KzPlatformPlatform extends PlatformInterface {
  KzPlatformPlatform() : super(token: _token);

  static final Object _token = Object();

  static KzPlatformPlatform _instance = MethodChannelKzPlatform();

  static KzPlatformPlatform get instance => _instance;

  static set instance(KzPlatformPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
