import 'package:feature/core/core_language.dart';
import 'package:feature/features/_core/di_and_mediator/global_mediator.dart';
import 'package:feature/features/home/domain/domain.dart';

abstract interface class PostDetailsController {
  Future<PostModel?> readPost(String id);
}
class PostDetailsControllerImpl implements PostDetailsController{
  final PostRepository repository;

  PostDetailsControllerImpl(this.repository);
@override
  Future<PostModel?> readPost(String id) async {
    try {
      final model=await repository.detailsOrThrow(id);
      Logger.on("PostDetailsControllerImpl", "readPost:$model");
      return model;
    } catch (e) {
      AppMediator.onError(e);
      Logger.on("PostDetailsControllerImpl", "readPostError:$e");
      return null;
    }

  }
}
