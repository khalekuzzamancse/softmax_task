import 'package:feature/features/home/domain/domain.dart';
import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  // Constructor to accept a PostModel object
  PostDetailsScreen({required this.post});

  @override
  Widget build(BuildContext context) {
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
            Text(post.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(post.body, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Tags: ${post.tags.join(', ')}', style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.visibility, size: 20, color: Colors.grey),
                SizedBox(width: 4),
                Text('${post.views} views', style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(width: 16),
                Icon(Icons.thumb_up, size: 20, color: Colors.blue),
                SizedBox(width: 4),
                Text('${post.likes}', style: TextStyle(fontSize: 14, color: Colors.blue)),
                SizedBox(width: 16),
                Icon(Icons.thumb_down, size: 20, color: Colors.red),
                SizedBox(width: 4),
                Text('${post.dislikes}', style: TextStyle(fontSize: 14, color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

