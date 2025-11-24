
import 'package:feature/core/core_ui.dart';
import 'package:feature/features/auth/data/data.dart';
import 'package:feature/features/auth/presentation/login_controller.dart';
import 'package:feature/features/auth/presentation/login_controller_impl.dart';
import 'package:feature/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';

//@formatter:off
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller=LoginControllerImpl(AuthRepositoryImpl.create());
  final TextEditingController _usernameController = TextEditingController(text: "emilys");
  final TextEditingController _passwordController = TextEditingController(text: "emilyspass");
  var error=LoginUiError();
  @override
  void initState() {
    super.initState();
    controller.onUserNameChanged("emilys");
    controller.onPasswordChanged("emilyspass");
    _usernameController.addListener(() {
      controller.onUserNameChanged(_usernameController.text);
    });
    _passwordController.addListener(() {
      controller.onPasswordChanged(_passwordController.text);
    });
    controller.errors.listen((event) {
      setState(() {
        error=event;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    errorText: error.userIdError,
                    onDone: () {

                    },),
                  passwordField:AuthTextField(
                    label: 'Password',
                    controller: _passwordController,
                    isPasswordField: true,
                    leadingIcon:Icons.lock ,
                    keyboardType: null,
                    errorText:error.passwordError,
                    onDone: () {

                    },
                  ),
                  resetPasswordAction: CustomTextButton(
                    label: "Forget Password ?",
                    onPressed: () {
                //      Navigation.navigateToResetPassword(context);
                    },

                  ),
                  actions: Column(
                    children: [
                      RoundedButton(
                          label: 'Login',
                          height: 48,
                          onPressed: () async{
                            // Hides the keyboard
                            FocusScope.of(context).unfocus();
                            //TODO:Fix about accessing context in async block
                            controller.login();
                            final success= await controller.login();
                            if(success){
                             context.push(HomeScreen());
                            }
                          }
                      ),
                      const SpacerVertical(16),
                      const Text('Or',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,color:AppColor.headingText)
                      ),
                        const SpacerVertical(16),
                      RoundedButton(
                          label: 'Create an account',
                          height: 48,
                          onPressed: () {

                          }
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}


///Inspired by Strategy Design Pattern
//@formatter:off
class _LayoutStrategy extends StatelessWidget {
  final Widget header, phoneNoField, passwordField, resetPasswordAction, actions;

  const _LayoutStrategy({Key? key, required this.header, required this.phoneNoField,
    required this.passwordField, required this.resetPasswordAction, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        header, // Display the header widget
        const SizedBox(height: 32),
        phoneNoField, // Phone number field
        const SizedBox(height: 16),
        passwordField, // Password field
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: resetPasswordAction,
        ), // Forget password field
        const SizedBox(height: 32),
        actions, // Login and register buttons
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
   //     Logo(),
        Text(
          "Login",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

