import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/pages/route_page.dart';
import 'package:pocket_flow/services/auth_service.dart';

class LoginRegisterPage extends StatefulWidget {
  final Widget page;
  const LoginRegisterPage({super.key, this.page = const SignInForm()});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -90, left: -70, child: Bubble(size: 0.6)),
          Positioned(top: 60, right: -90, child: Bubble(size: 0.4)),
          Positioned(bottom: -100, right: -100, child: Bubble(size: 0.7)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
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
                      SingleChildScrollView(
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
  late int buttonID;
  late bool isGoogleButtonActive;

  Widget _buttonSelector(int buttonId) {
    switch (buttonId) {
      case 0:
        return ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                buttonID = 1;
              });
              final bool isUserVerified = await AuthService.isUserVerified(
                _emailController.text,
                _passwordController.text,
              );
              if (mounted) {
                setState(() {
                  buttonID = 0;
                });
                if (isUserVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Successfully logged in'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.sm),
                          topRight: Radius.circular(AppRadius.sm),
                        ),
                      ),
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const RoutePage()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: 'ERROR: user does not exist',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: AppColors.expenseContainer,
                    textColor: AppColors.expense,
                    fontSize: 16.0,
                  );
                }
              }
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
        );
      case 1:
        return SizedBox(
          width: double.infinity,
          child: Center(child: CircularProgressIndicator()),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _googleButtonActivator(bool isActive) {
    if (isActive) {
      return OutlinedButton(
        onPressed: () async {
          setState(() {
            isGoogleButtonActive = false;
          });
          final result = await AuthService.signInWithGoogle();
          if (result && mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const RoutePage()),
              (route) => false,
            );
          } else {
            setState(() {
              isGoogleButtonActive = true;
            });
            Fluttertoast.showToast(
              msg: 'ERROR: try again',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: AppColors.expenseContainer,
              textColor: AppColors.expense,
              fontSize: 16.0,
            );
          }
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
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    isGoogleButtonActive = true;
    isPasswordValid = false;
    isEmailValid = false;
    buttonID = 0;
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
                  onSaved: (String? p1) {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Forget Password?')),
                  ],
                ),
                _buttonSelector(buttonID),
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
        _googleButtonActivator(isGoogleButtonActive),
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

  late bool isShowButton;

  @override
  void initState() {
    super.initState();
    isPasswordValid = false;
    isPasswordsMatch = false;
    isEmailValid = false;
    isNameValid = false;
    isShowButton = true;
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
                  onSaved: (String? p1) {},
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
                  onSaved: (String? p1) {},
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
                  onSaved: (String? p1) {},
                ),
                SizedBox(height: CustomSize.defaultPadding),
                (!isShowButton)
                    ? SizedBox(
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isShowButton = false;
                            });
                            final bool isSuccess;
                            _formKey.currentState!.save();
                            isSuccess = await AuthService.emailRegistration(
                              _emailController.text,
                              _passwordController.text,
                            );
                            setState(() {
                              isShowButton = true;
                            });

                            if (isSuccess && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Verification email was sent'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(AppRadius.sm),
                                      topRight: Radius.circular(AppRadius.sm),
                                    ),
                                  ),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginRegisterPage(
                                    page: EmailVerifyWidget(email: _emailController.text),
                                  ),
                                ),
                              );
                            }
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
  Timer? timer;
  Timer? timer2;
  late int buttonID;
  late int countDown;

  Widget _button(int buttonId) {
    switch (buttonId) {
      case 0:
        return OutlinedButton(
          onPressed: () async {
            setState(() {
              buttonID = 1;
            });
            final bool resendEmail = await AuthService.resendVerificationEmail();
            if (mounted) {
              if (!resendEmail) {
                setState(() {
                  buttonID = 0;
                });
                Fluttertoast.showToast(
                  msg: 'ERROR: try again',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 3,
                  backgroundColor: AppColors.expenseContainer,
                  textColor: AppColors.expense,
                  fontSize: 16.0,
                );
              } else {
                setState(() {
                  buttonID = 2;
                  countDown = 59;
                });
                timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
                  (countDown > 0)
                      ? setState(() {
                          countDown -= 1;
                        })
                      : setState(() {
                          timer2!.cancel();
                          buttonID = 0;
                        });
                });
              }
            }
          },
          style: OutlinedButton.styleFrom(
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
        );
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [CircularProgressIndicator()],
        );
      case 2:
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: AppColors.surface,
          ),
          child: Text(
            '00 : ${countDown.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final verified = await AuthService.isEmailVerified();
      if (!verified || !mounted) return;

      timer?.cancel();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RoutePage()),
        (route) => false,
      );
    });
    buttonID = 0;
    countDown = 0;
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

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
          'We sent a verification link to ${widget.email} \nOpen it,then come back here.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(height: CustomSize.defaultPadding),
        _button(buttonID),
        SizedBox(height: CustomSize.defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.currentUser?.delete();
                } on FirebaseAuthException {
                  await FirebaseAuth.instance.signOut();
                }
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginRegisterPage(page: SignUpForm()),
                  ),
                  (route) => false,
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
