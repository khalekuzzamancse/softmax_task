part of 'login_screen.dart';

/// Inspired by the Strategy Design Pattern
///
/// This helps to swap layouts and alignments without being concerned about the actual content.
/// It also makes the code more readable and reduces the responsibility of the view.

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
