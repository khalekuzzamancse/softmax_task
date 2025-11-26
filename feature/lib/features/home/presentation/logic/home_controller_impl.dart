import 'package:feature/core/core_language.dart';
import 'package:feature/features/_core/global_mediator.dart';
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/logic/home_controller.dart';
import 'package:kz_platform/image_classifier.dart';
import 'package:rxdart/rxdart.dart';

class HomeControllerImpl implements HomeController {
  final AuthRepository authRepository;
  final PostRepository postRepository;
  final _posts=BehaviorSubject<List<PostModel>>.seeded([]);
  String? _nextUrl;
  late final tag = runtimeType.toString();

  HomeControllerImpl({
    required this.authRepository,
    required this.postRepository,
  });

  @override
  Stream<List<PostModel>> get posts => _posts.stream;
  @override
  Future<void> readPost() async {
    try {
      final wrapper = await postRepository.readOrThrow(null);
      _nextUrl = wrapper.nextUrl;
      _posts.add(wrapper.data);
    } catch (e) {
      AppMediator.onError(e);
       List.empty();
    }
  }

  @override
  Future<UserModel?> readUser() async {
    try {
      final model = await authRepository.userOrThrow();
      Logger.off(tag, "user:$model");
      return model;
    } catch (e) {
      AppMediator.onError(e);
      Logger.off(tag, "userReadError:$e");
      return null;
    }
  }

  @override
  Future<void> readNext() async {
    if (_nextUrl == null) return null;
    try {
      final wrapper = await postRepository.readOrThrow(_nextUrl);
      _nextUrl = wrapper.nextUrl;
      _posts.add(wrapper.data);
    } catch (e) {
      AppMediator.onError(e);

    }
  }

  @override
  Future<void> search(String query) async {
    try{
      Logger.off(tag, "search:query=$query");
      if (query.isEmpty) {
         return await readPost();
      }
       final wrapper= await postRepository.searchOrThrow(query);
      _posts.add(wrapper.data);
    }
    catch(e){
      AppMediator.onError(e);
      Logger.off(tag, "search:Error=$e");
      return null;
    }
  }

}
