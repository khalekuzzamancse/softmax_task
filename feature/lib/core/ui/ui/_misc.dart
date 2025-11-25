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








class BackHandlerDecorator extends StatelessWidget {
  final Widget child;

  const BackHandlerDecorator({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if the back stack is empty
        if (!Navigator.canPop(context)) {
          // If no routes to pop, show a dialog or a custom message
          final shouldExit = await _showExitDialog(context);
          if (shouldExit) {
            // Exit the app or perform any action
            // For example: SystemNavigator.pop(); // Uncomment to exit the app
            return true; // Allow the pop
          }
          return false; // Don't pop if exit is not confirmed
        }
        return true; // Allow the pop action if there are routes in the stack
      },
      child: child,
    );
  }

  // Show exit confirmation dialog
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit"),
          content: Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Don't pop
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Allow pop
              child: Text("Yes"),
            ),
          ],
        );
      },
    ) ??
        false; // Default if dialog is dismissed
  }
}



