import 'package:feature/core/core_ui.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/ui/post_details_screen.dart';
import 'package:flutter/material.dart';



class PostListScreen extends StatefulWidget {
  final List<PostModel> posts;
  final void Function()? onListEnd;
  PostListScreen({required this.posts, this.onListEnd});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        if (widget.onListEnd != null) {
          widget.onListEnd!();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        final post = widget.posts[index];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold,overflow:TextOverflow.ellipsis ),maxLines: 1,),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.body, maxLines:1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 8),
                Text('Tags: ${post.tags.join(', ')}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.visibility, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${post.views} views', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(width: 16),
                    Icon(Icons.thumb_up, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text('${post.likes}', style: TextStyle(fontSize: 12, color: Colors.blue)),
                    SizedBox(width: 16),
                    Icon(Icons.thumb_down, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text('${post.dislikes}', style: TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ),
              ],
            ),
            onTap: () {
              context.push(PostDetailsScreen(post:post ));
            },
          ),
        );
      },
    );
  }
}
