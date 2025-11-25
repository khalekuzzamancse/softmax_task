part of '../../core_ui.dart';


///To change it size need to
class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Placeholder();
    // return  const RenderImg(
    //   path: Images.logo,
    //   height: 70,
    //   width: 100,
    // );
  }
}
extension SafeUpdateState on State {
  void safeSetState(void Function() updaterFunction) {
    void callSetState() {
      // Can only call setState if mounted
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(updaterFunction);
      }
    }


    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Currently building, can't call setState --
      // need to add post-frame callback
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}
extension ContextExtension on BuildContext{
  Future<T?> push<T extends Object?>(Widget route)async{
    return await Navigator.push(this, MaterialPageRoute(builder: (_)=>route));
  }
  void pop<T extends Object?>([ T? result ]){
    return Navigator.pop(this,result);
  }
  ///In case of async-gap the context may  be invalid so can use it anywhere
  ///to prevent crash
  void popSafelyOrSkip<T extends Object?>([ T? result ]){
    if(mounted){
      Navigator.pop(this,result);
    }
  }
}

String? _currentMsg;
void showSnackBar(String? message,{String? tag})async {
  if(tag!=null){
    Logger.on('$tag::showSnackBar', '$message');
  }
  //already the same message shown
  if(_currentMsg==message){
    return;
  }
  _currentMsg=message;
  if(message==null) {
    return;
  }
  await Get.snackbar('','',
      titleText: Text(message),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,
      borderRadius: 10,
      backgroundColor: Colors.green,
      maxWidth: 300)
      .future;
  _currentMsg=null;
}
