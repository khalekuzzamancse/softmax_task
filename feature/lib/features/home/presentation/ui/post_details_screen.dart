import 'package:feature/core/core_ui.dart';
import 'package:feature/features/_core/di_and_mediator/di_container.dart';
import 'package:feature/features/home/data/data.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/logic/post_details_controller.dart';
import 'package:feature/features/misc/misc.dart';
import 'package:flutter/material.dart';

class PostDetailsScreen extends StatefulWidget {
  final String id;

  PostDetailsScreen(this.id);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen>
    with LoadingStateMixin {
  late final controller = DiContainer.postDetailsController();
  PostModel? _model;

  @override
  void initState() {
    super.initState();
    read();
  }

  void read() async {
    startLoading();
    final model = await controller.readPost(widget.id);
    safeSetState(() {
      isLoading = false;
      _model = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = _model;
    if (isLoading) {
      return Material(child: FullScreenShimmerEffect());
    }
    if (post == null) {
      return Material(child: Center(child: Text("No post found")));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(post.body, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text(
                'Tags: ${post.tags.join(', ')}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.visibility, size: 20, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${post.views} views',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.thumb_up, size: 20, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    '${post.likes}',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.thumb_down, size: 20, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    '${post.dislikes}',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
