part of '../data_source.dart';

void throwFailureOrSkip(String response, String tag) {
  var throwed=false;
  try {
    final json=jsonDecode(response) as Json;
    Logger.off("throwFailureOrSkip::", "response=$response");
    final String? message =json["message"];
    Logger.off("throwFailureOrSkip::", "message=$message");
    if (message != null) {
      throwed=true;
      throw CustomException(message: message, debugMessage: tag);

    }
  } catch (e) {
    if(throwed){ rethrow;}
    Logger.off("throwFailureOrSkip::", "error=$e");
  }
}
