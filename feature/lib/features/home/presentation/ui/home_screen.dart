import 'package:feature/core/core_ui.dart';
import 'package:feature/features/auth/data/data.dart' show AuthRepositoryImpl;
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/home/data/data.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/logic/home_controller_impl.dart';
import 'package:feature/features/home/presentation/ui/post_list.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:kz_platform/image_classifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  List<PostModel> posts = [];
  late final controller = HomeControllerImpl(
    authRepository: AuthRepositoryImpl.create(),
    postRepository: PostRepositoryImpl.create(),
  );

  @override
  void initState() {
    super.initState();
    controller.readUser();
    controller.readPost();
    controller.user.listen((event) {
      setState(() {
        user = event;
      });
    });

    controller.posts.listen((event) {
      setState(() {
        posts = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = user?.username;
    final image = user?.image;

    return Scaffold(
      appBar: AppBar(
        title: TextHeading3(text: name ?? 'Loading..'),
        leading: image == null
            ? LoadingUI()
            : Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(image),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.device_unknown),
        onPressed: ()async {
          final name= await CorePlatform().deviceName();
          final version = await CorePlatform().getPlatformVersion();
          showDeviceInfoDialog(context, name, version);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBarWidget(onQuery: controller.search),
          ),
          Expanded(child: PostListScreen(posts: posts,onListEnd: controller.onPostListEnd,)),
        ],
      ),
    );
  }
}



Future<void> showDeviceInfoDialog(
    BuildContext context,
    String name,
    String version,
    ) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          'Device Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Device Name
              Row(
                children: [
                  Icon(Icons.device_hub, color: Colors.blue, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Device Name: $name',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // Platform Version
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Platform Version: $version',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
}

