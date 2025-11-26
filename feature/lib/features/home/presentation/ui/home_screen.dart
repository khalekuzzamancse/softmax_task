import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_ui.dart';
import 'package:feature/features/_core/di_container.dart';
import 'package:feature/features/_core/global_mediator.dart';
import 'package:feature/features/auth/data/data.dart' show AuthRepositoryImpl;
import 'package:feature/features/home/data/data.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/logic/home_controller.dart';
import 'package:feature/features/home/presentation/logic/home_controller_impl.dart';
import 'package:feature/features/misc/misc.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:kz_platform/image_classifier.dart';
import 'package:feature/features/home/presentation/ui/post_details_screen.dart';
import 'package:flutter/material.dart';

part '_view_controller.dart';

part '_post_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final controller = DiContainer.homeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(controller),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.device_unknown, color: Colors.green),
        onPressed: () async {
          final name = await CorePlatform().deviceName();
          final version = await CorePlatform().getPlatformVersion();
          showDeviceInfoDialog(context, name, version);
        },
      ),
      body: Column(
        children: [
          SpacerVertical(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBarWidget(onQuery: controller.search),
          ),
          SpacerVertical(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DividerHorizontal(),
          ),
          Expanded(child: PostListScreen(controller)),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final HomeController controller;

  CustomAppBar(this.controller);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> with LoadingStateMixin {
  String? name;
  String? image;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    startLoading();
    final user = await widget.controller.readUser();
    Logger.on("CustomAppBar", "user:$user");
    if (user != null) {
      safeSetState(() {
        isLoading = false;
        name = user.username;
        image = user.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Expanded(
              child: isLoading?FullScreenShimmerEffect():Row(
                children: [
                  SpacerHorizontal(16),
                  image == null
                      ? SizedBox.shrink()
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(image!),
                        ),
                  SpacerHorizontal(16),
                  Expanded(
                    child: Text(
                      name != null ? capitalizeEachWord(name!) : 'Loading...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SpacerHorizontal(4),
            IconButton(
              onPressed: () {
                AppMediator.instance.onSessionExpire();
              },
              icon: Icon(Icons.logout, color: AppColor.primary),
            ),
            SpacerHorizontal(4),
          ],
        ),
      ),
    );
  }

  String capitalizeEachWord(String name) {
    try {
      return name
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : word,
          )
          .join(' ');
    } catch (_) {
      return name;
    }
  }
}

Future<void> showDeviceInfoDialog(
  BuildContext context,
  String name,
  String version,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    // Prevent dismissing the dialog by tapping outside
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
