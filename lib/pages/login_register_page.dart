import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/pages/route_page.dart';

class LoginRegisterPage extends StatefulWidget {
  final Widget page;
  const LoginRegisterPage({super.key, this.page = const SignInForm()});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: true,
      title: 'pocket flow app',
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(top: -90, left: -70, child: Bubble(size: 0.6)),
            Positioned(top: 60, right: -90, child: Bubble(size: 0.4)),
            Positioned(bottom: -100, right: -100, child: Bubble(size: 0.7)),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomSize.defaultPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 76,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: CustomSize.defaultPadding),
                    Text(
                      'Pocket Flow',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Track • Manage • Grow',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: CustomSize.defaultPadding),
                    Container(
                      padding: EdgeInsets.all(CustomSize.defaultPadding * 2),
                      margin: EdgeInsets.all(CustomSize.defaultPadding),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border, width: 1),
                        color: AppColors.surface,
                      ),
                      child: widget.page,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final double size;
  const Bubble({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = max(0.0, MediaQuery.of(context).size.width);
    final mul = ((0 < size && size < 1) ? size : 1);
    return Container(
      width: deviceWidth * mul,
      height: deviceWidth * mul,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        color: AppColors.primaryContainer,
      ),
    );
  }
}

class InputBox extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final dynamic Function(String?) validator;
  final void Function(String?) onSaved;
  const InputBox({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    required this.isPassword,
    required this.validator,
    required this.onSaved,
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late bool hidePassword;

  @override
  void initState() {
    super.initState();
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: widget.controller,
        obscureText: (widget.isPassword) ? hidePassword : widget.isPassword,
        enableSuggestions: !widget.isPassword,
        autocorrect: !widget.isPassword,
        validator: (value) {
          return widget.validator(value);
        },
        onSaved: (newValue) {
          widget.onSaved(newValue);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(color: AppColors.border, width: 1),
          ),
          label: Text(widget.label, style: TextStyle(color: AppColors.textSecondary)),
          fillColor: AppColors.surfaceVariant,
          prefixIcon: Icon(widget.prefixIcon, color: AppColors.textSecondary),
          suffixIcon: (widget.isPassword)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    (hidePassword) ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late bool isPasswordValid;
  late bool isEmailValid;

  @override
  void initState() {
    super.initState();
    isPasswordValid = false;
    isEmailValid = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Login to continue to your account',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(height: 24),
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputBox(
                  controller: _emailController,
                  label: 'Email Address',
                  prefixIcon: Icons.email,
                  isPassword: false,
                  validator: (p0) {
                    final emailRegex = RegExp(
                      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
                    );
                    if (emailRegex.hasMatch(_emailController.text)) {
                      isEmailValid = true;
                      return null;
                    } else {
                      return 'Enter a valid email address';
                    }
                  },
                  onSaved: (String? p1) {},
                ),
                InputBox(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (p0) {
                    final passwordRegex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9])[\x21-\x7E]{6,}$',
                    );
                    if (passwordRegex.hasMatch(_passwordController.text)) {
                      isPasswordValid = true;
                      return null;
                    } else {
                      return 'upper & lowercase, number, symbol, 5+ characters';
                    }
                  },
                  onSaved: (String? p1) {
                    _passwordController.text = '';
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Forget Password?')),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Done')));

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoutePage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [Text('Login'), Icon(Icons.arrow_right)],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: CustomSize.defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or continue with',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: CustomSize.defaultPadding),
        OutlinedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RoutePage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            side: BorderSide(color: AppColors.border, width: 1),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/google_logo.png', height: 22),
              const SizedBox(width: 10),
              const Text('Login with Google'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: CustomSize.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginRegisterPage(page: SignUpForm()),
                    ),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  late bool isPasswordValid;
  late bool isPasswordsMatch;
  late bool isEmailValid;
  late bool isNameValid;

  @override
  void initState() {
    super.initState();
    isPasswordValid = false;
    isPasswordsMatch = false;
    isEmailValid = false;
    isNameValid = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Start your journey with Pocket Flow',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(height: 24),
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputBox(
                  controller: _nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.account_circle,
                  isPassword: false,
                  validator: (p0) {
                    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                    if (nameRegex.hasMatch(_nameController.text.trim())) {
                      isNameValid = true;
                      return null;
                    } else {
                      return 'Enter a valid name';
                    }
                  },
                  onSaved: (String? p1) {
                    _nameController.text = '';
                  },
                ),
                InputBox(
                  controller: _emailController,
                  label: 'Email Address',
                  prefixIcon: Icons.email,
                  isPassword: false,
                  validator: (p0) {
                    final emailRegex = RegExp(
                      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
                    );
                    if (emailRegex.hasMatch(_emailController.text)) {
                      isEmailValid = true;
                      return null;
                    } else {
                      return 'Enter a valid email address';
                    }
                  },
                  onSaved: (String? p1) {},
                ),
                InputBox(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (p0) {
                    final passwordRegex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9])[\x21-\x7E]{6,}$',
                    );
                    if (passwordRegex.hasMatch(_passwordController.text)) {
                      isPasswordValid = true;
                      return null;
                    } else {
                      return 'upper & lowercase, number, symbol, 5+ characters';
                    }
                  },
                  onSaved: (String? p1) {
                    _passwordController.text = '';
                  },
                ),
                InputBox(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (p0) {
                    if (_passwordController.text == _confirmPasswordController.text) {
                      isPasswordsMatch = true;
                      return null;
                    } else {
                      return 'Password does not match';
                    }
                  },
                  onSaved: (String? p1) {
                    _confirmPasswordController.text = '';
                  },
                ),
                SizedBox(height: CustomSize.defaultPadding),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Done')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginRegisterPage(
                            page: EmailVerifyWidget(email: _emailController.text),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [Text('Create Account'), Icon(Icons.arrow_right)],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: CustomSize.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginRegisterPage(page: SignInForm()),
                    ),
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EmailVerifyWidget extends StatefulWidget {
  final String email;
  const EmailVerifyWidget({super.key, required this.email});

  @override
  State<EmailVerifyWidget> createState() => _EmailVerifyWidgetState();
}

class _EmailVerifyWidgetState extends State<EmailVerifyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your email',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'We sent a verification link to ${widget.email}. Open it,then come back here.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(height: CustomSize.defaultPadding),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RoutePage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [Text("I've verified"), Icon(Icons.arrow_right)],
          ),
        ),
        SizedBox(height: CustomSize.defaultPadding),
        OutlinedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.border, width: 1),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [const Text('Resend verification email')],
          ),
        ),
        SizedBox(height: CustomSize.defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginRegisterPage(page: SignUpForm()),
                  ),
                );
              },
              child: Text(
                'Use a different email',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
