part of 'home_screen.dart';

class PostListScreen extends StatefulWidget {
  final HomeController controller;

  PostListScreen(this.controller);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>
    with LoadingStateMixin {
  final scrollController = ScrollController();
  late final controller = widget.controller;
  List<PostModel> posts = [];
  var nextLoading = false;
  late final _ = PostListViewController();

  @override
  //@formatter:off
  void initState() {
    super.initState();
    _.init(this);
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        _.onListEnd(this);
      }
    });
    controller.posts.listen((event) {
      safeSetState(() {
        posts = event;
      });
    });
  }

  void onNextLoading(bool loading) => safeSetState(() {
    nextLoading = loading;
  });
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return FullScreenShimmerEffect();
    }

   else {
      return RefreshIndicator(
        onRefresh:(){
          return _.onPulled(this);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: posts.isEmpty? NoDataView():
          ListView.builder(
            itemCount: posts.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              final post = posts[index];
              final isLast = index == posts.length - 1;
              if(nextLoading&&isLast) {
                return Align(alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Loading...'),
                    ));
              } else  return Card(
                margin: EdgeInsets.only(top: 16, bottom: isLast ? 16 : 0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    post.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tags: ${post.tags.join(', ')}',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.visibility, size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            '${post.views} views',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.thumb_up, size: 16, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            '${post.likes}',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.thumb_down, size: 16, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            '${post.dislikes}',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push(PostDetailsScreen(post.id));
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
