import 'package:feature/features/auth/data/data.dart';
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/auth/presentation/logic/login_controller.dart';
import 'package:feature/features/auth/presentation/logic/login_controller_impl.dart';
import 'package:feature/features/home/data/data.dart';
import 'package:feature/features/home/domain/domain.dart';
import 'package:feature/features/home/presentation/logic/home_controller.dart';
import 'package:feature/features/home/presentation/logic/home_controller_impl.dart';
import 'package:feature/features/home/presentation/logic/post_details_controller.dart';

class DiContainer {
  static HomeController homeController() => HomeControllerImpl(
    authRepository: RepositoryContainer.authRepository,
    postRepository: RepositoryContainer.postRepository,
  );
  static LoginController loginController() =>LoginControllerImpl(
    RepositoryContainer.authRepository,
  );
  static PostDetailsController postDetailsController ()=>
      PostDetailsControllerImpl(RepositoryContainer.postRepository);
}

class RepositoryContainer {
  static AuthRepository authRepository = AuthRepositoryImpl.create();
  static PostRepository postRepository = PostRepositoryImpl.create();
}
