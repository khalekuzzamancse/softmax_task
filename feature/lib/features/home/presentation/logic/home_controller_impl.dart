import 'package:feature/core/core_language.dart';
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/logic/home_controller.dart';
import 'package:kz_platform/image_classifier.dart';
import 'package:rxdart/rxdart.dart';

class HomeControllerImpl implements HomeController {
  final AuthRepository authRepository;
  final PostRepository postRepository;
  final _user=BehaviorSubject<UserModel?>.seeded(null);
  final _posts=BehaviorSubject<List<PostModel>>.seeded([]);
  final _isLoading=BehaviorSubject<bool>.seeded(false);
  final _isNextLoading=BehaviorSubject<bool>.seeded(false);
  var _lastQuery="";
  String? _nextUrl;
  late final tag=runtimeType.toString();

  HomeControllerImpl({
    required this.authRepository,
    required this.postRepository,
  });

  @override
  Stream<bool> get isLoading => _isLoading.stream;
  @override
  Stream<bool> get isNextLoading => _isNextLoading.stream;
  @override
  Stream<UserModel?> get user => _user.stream;
  @override
  Stream<List<PostModel>> get posts =>_posts.stream;


  @override
  void readPost() async{
    try {
      final wrapper= await postRepository.readOrThrow(null);
      _posts.add(wrapper.data);
      _nextUrl=wrapper.nextUrl;
    }
    catch (_) {}
  }

  @override
  void readUser() async{
    try {
      final model= await authRepository.userOrThrow();
      _user.add(model);
      Logger.off(tag, "user:$model");
    }
    catch (e) {
      Logger.on(tag, "userReadError:$e");
    }
  }

  @override
  void onPostListEnd()async {
    Logger.on(tag, "onPostListEnd:$_nextUrl");
    if(_nextUrl==null) return;
    try {
      final wrapper= await postRepository.readOrThrow(_nextUrl);
      _posts.add(_posts.value+wrapper.data);
      _nextUrl=wrapper.nextUrl;

    }
    catch (_) {}
  }

  @override
  void search(String query) async{
    _lastQuery=query;
    Logger.on(tag, "search:$query");
    final name=await CorePlatform().deviceName();
    Logger.on(tag, "name:$name");
    final version=await CorePlatform().getPlatformVersion();

    Logger.on(tag, "version:$version");
    if(query.isEmpty&&query!=_lastQuery){

    }

  }
}
