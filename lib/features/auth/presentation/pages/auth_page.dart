import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:focus_craftz_application/core/theme/app_colors.dart';
import 'package:focus_craftz_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focus_craftz_application/features/auth/presentation/widgets/desk_illustration.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _obscureLoginPw = true;

  final _registerFormKey = GlobalKey<FormState>();
  final _registerEmail = TextEditingController();
  final _registerPassword = TextEditingController();
  final _registerConfirm = TextEditingController();
  bool _obscureRegisterPw = true;
  bool _obscureRegisterConfirm = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _registerEmail.dispose();
    _registerPassword.dispose();
    _registerConfirm.dispose();
    super.dispose();
  }

  void _switchPage(int index) {
    if (_currentPage == index) return;
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSignIn() {
    if (!_loginFormKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignInRequested(
          email: _loginEmail.text.trim(),
          password: _loginPassword.text,
        ));
  }

  void _onSignUp() {
    if (!_registerFormKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignUpRequested(
          email: _registerEmail.text.trim(),
          password: _registerPassword.text,
        ));
  }

  void _onGoogleSignIn() {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ));
          }
        },
        child: Column(
          children: [
            const SizedBox(height: 240, child: DeskIllustration()),
            _buildToggle(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLoginTab(),
                  _buildRegisterTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.inputBorder,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _toggleTab('Sign In', 0),
            _toggleTab('Create Account', 1),
          ],
        ),
      ),
    );
  }

  Widget _toggleTab(String label, int index) {
    final isActive = _currentPage == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchPage(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildAppIcon(),
          const SizedBox(height: 12),
          const Column(
            children: [
              Text(
                'FocusCraftz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your cozy focus companion ☕',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildLoginForm(),
          const SizedBox(height: 8),
          _buildForgotPassword(),
          const SizedBox(height: 20),
          _buildSignInButton(),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 14),
          _buildSocialButton(
            label: 'Continue with Google',
            icon: _GoogleIcon(),
            onTap: _onGoogleSignIn,
          ),
          const SizedBox(height: 10),
          _buildSocialButton(
            label: 'Continue with Apple',
            icon: const Icon(
              Icons.apple_rounded,
              size: 22,
              color: AppColors.textPrimary,
            ),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Apple Sign-In coming soon.'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Start your focus journey today ✨',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          _buildRegisterForm(),
          const SizedBox(height: 24),
          _buildSignUpButton(),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildAppIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.illustrationBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.timer_outlined,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('EMAIL'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _loginEmail,
            hintText: 'hello@focuscraftz.app',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter your email.';
              if (!v.contains('@')) return 'Please enter a valid email.';
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildLabel('PASSWORD'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _loginPassword,
            hintText: '••••••••••',
            obscureText: _obscureLoginPw,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLoginPw
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureLoginPw = !_obscureLoginPw),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your password.';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('EMAIL'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _registerEmail,
            hintText: 'hello@focuscraftz.app',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter your email.';
              if (!v.contains('@')) return 'Please enter a valid email.';
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildLabel('PASSWORD'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _registerPassword,
            hintText: '••••••••••',
            obscureText: _obscureRegisterPw,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureRegisterPw
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureRegisterPw = !_obscureRegisterPw),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter a password.';
              if (v.length < 6) return 'Password must be at least 6 characters.';
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildLabel('CONFIRM PASSWORD'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _registerConfirm,
            hintText: '••••••••••',
            obscureText: _obscureRegisterConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureRegisterConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
              onPressed: () => setState(
                  () => _obscureRegisterConfirm = !_obscureRegisterConfirm),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password.';
              if (v != _registerPassword.text) return 'Passwords do not match.';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
        filled: true,
        fillColor: AppColors.inputBackground,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    'Start Focusing →',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    'Create Account →',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 20, height: 20, child: _GoogleColorIcon());
  }
}

class _GoogleColorIcon extends StatelessWidget {
  const _GoogleColorIcon();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GooglePainter());
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    void arc(Color color, double start, double sweep) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.18,
      );
    }

    arc(const Color(0xFF4285F4), -0.52, 1.57);
    arc(const Color(0xFFEA4335), -2.09, 1.57);
    arc(const Color(0xFFFBBC04), 2.09, 1.05);
    arc(const Color(0xFF34A853), 3.14, 1.05);

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.72, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = size.width * 0.18
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
