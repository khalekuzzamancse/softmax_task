import 'package:feature/core/core_ui.dart';
import 'package:feature/features/auth/data/data.dart';
import 'package:feature/features/auth/presentation/logic/login_controller.dart';
import 'package:feature/features/auth/presentation/logic/login_controller_impl.dart';
import 'package:feature/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
part '_view_controller.dart';
part '_view_strategy.dart';

//@formatter:off
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  with LoadingStateMixin{
  final LoginController controller=LoginControllerImpl(AuthRepositoryImpl.create());
  final TextEditingController _usernameController = TextEditingController(text: "emilys");
  final TextEditingController _passwordController = TextEditingController(text: "emilyspass");
  late var error=LoginUiError();
  late final _=LoginViewController();

  @override
  void initState() {
    super.initState();
    _.init(this);
  }

  @override
  void dispose() {
    _.dispose(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final enabled=!isLoading;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints:const BoxConstraints(
                      maxWidth: 500
                  ),
                child: _LayoutStrategy(
                    header: const _Header(),
                    phoneNoField: AuthTextField(
                      controller: _usernameController,
                      label: 'Phone number or email',
                      leadingIcon: Icons.person,
                      keyboardType: TextInputType.text,
                      errorText: error.userIdError),
                    passwordField:AuthTextField(
                      label: 'Password',
                      controller: _passwordController,
                      isPasswordField: true,
                      leadingIcon:Icons.lock ,
                      keyboardType: null,
                      errorText:error.passwordError,
                    ),
                    resetPasswordAction: SizedBox.shrink(),
                    actions: Column(
                      children: [
                        RoundedButton(
                            label: 'Login',
                            height: 48,
                            backgroundColor: enabled?AppColor.primary:Colors.grey,
                            onPressed:enabled? () async{
                              _.login(this);
                            }:null
                        ),
                        const SpacerVertical(16),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


