export 'di_and_mediator/global_mediator.dart';

import 'package:flutter/material.dart';

import 'features/auth/presentation/ui/login_screen.dart';

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
