export 'features/_core/di_and_mediator/global_mediator.dart';

import 'package:app_links/app_links.dart';
import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_ui.dart';
import 'package:feature/features/_core/di_and_mediator/auth_preserver_controller.dart';
import 'package:feature/features/_core/di_and_mediator/global_mediator.dart';
import 'package:feature/features/home/presentation/ui/home_screen.dart';
import 'package:feature/features/home/presentation/ui/post_details_screen.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/ui/login_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool? isLoggedIn;
  String? postId;

  @override
  void initState() {
    super.initState();
    deepLink();
    AppMediator.setOnSessionExpire(() async {
      Logger.on("EntryPoint", 'onSessionExpire');
      AuthPreserverController.clear();
      safeSetState(() {
        isLoggedIn = null;
      });
      safeSetState(() {
        isLoggedIn = false;
      });
    });
    init();
  }


  void deepLink() async {
    final appLinks = AppLinks();
    final link = await appLinks.getInitialLink(); // Retrieve the deep link
    Logger.on("EntryPoint", 'deepLink: $link');
    if (link != null) {
      final String? id = link.queryParameters['id'];
      if (id != null) {
        setState(() {
          postId = id;
        });
   //     context.push(PostDetailsScreen(id));
      } else {

      }
    }
  }


  void init() async {
    try {
      await delayInMs(1500);
      await AuthPreserverController.readAccessTokenOrThrow();
      safeSetState(() {
        isLoggedIn = true;
      });
    } catch (_) {
      safeSetState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(postId!=null){
      return PostDetailsScreen(postId!);
    }
    if (isLoggedIn == null)
    if (isLoggedIn == null) {
      return SplashScreen();
    }
    if (isLoggedIn == true) {
      return HomeScreen();
    } else {
      return LoginScreen(
        onLoginSuccess: () {
          safeSetState(() {
            isLoggedIn = true;
          });
        },
      );
    }
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Background color for the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.star,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to MyApp',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
