
import 'package:feature/entry_point.dart';
import 'package:flutter/material.dart';

void main() {
  AppMediator.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(body: SnackBarDecorator(child: FeatureEntryPoint())),
    );
  }
}

class SnackBarDecorator extends StatefulWidget {
  final Widget child;

  const SnackBarDecorator({super.key, required this.child});

  @override
  State<SnackBarDecorator> createState() => _SnackBarDecoratorState();
}

class _SnackBarDecoratorState extends State<SnackBarDecorator> {
  @override
  void initState() {
    super.initState();

    AppMediator.messageToUI.listen((message) {
      if (message != null) {
        final snackBar = SnackBar(
          content: Text(message),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
