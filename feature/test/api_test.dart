import 'package:feature/core/core_language.dart';
import 'package:feature/core/data_source/data_source.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_mediator.dart';

void main() {
  final tag="ApiTest";
  setUpAll(()async{
    final api = ApiFactory.create().auth();
    final response = await api.loginOrThrow('emilys', 'emilyspass');
    TestMediator.setTokens(response.first, response.second);
    await TestMediator.instance.init();
    Logger.off(tag, "loginTest::response=$response");
  });
  test('login test', () async {
    final api = ApiFactory.create().auth();
    final response = await api.loginOrThrow('emilys', 'emilyspass');
    Logger.off(tag, "loginTest::response=$response");
  });

  test('read user test', () async {
    final api = ApiFactory.create().auth();
    final response = await api.userOrThrow();
    Logger.off(tag, "readUserTest::response=$response");
  });

  test('read post test', () async {
    final api = ApiFactory.create().post();
    final response = await api.readOrThrow(null);
    Logger.off(tag, "readPostTest::response=$response");
  });

  test('read post details test', () async {
    final api = ApiFactory.create().post();
    final response = await api.detailsOrThrow("1");
    Logger.on(tag, "readPostDetailsTest::response=$response");
  });
}
