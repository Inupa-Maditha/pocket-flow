import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/pages/login_register_page.dart';
import 'package:pocket_flow/services/auth_service.dart';
import 'package:pocket_flow/shared/shared_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isClickedSignOut;
  late bool isConfirmedSignOut;
  late bool isClickedDeleteAccount;
  final TextEditingController confirmationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isClickedSignOut = false;
    isConfirmedSignOut = false;
    isClickedDeleteAccount = false;
  }

  @override
  void dispose() {
    confirmationController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    SharedData.setTransactions = [];
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginRegisterPage()),
      (route) => false,
    );
  }

  Future<void> _logout() async {
    setState(() => isClickedSignOut = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Do you want to Logout?'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: AppColors.primary)),
                    ),
                    (isConfirmedSignOut)
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              setDialogState(() => isConfirmedSignOut = true);
                              final result = await AuthService.signOutUser();
                              if (!mounted) return;
                              if (result) {
                                _goToLogin();
                              } else {
                                setState(() => isClickedSignOut = false);
                              }
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: AppColors.expense),
                            ),
                          ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // confirm password (Google user => empty string), cancel => null
  Future<String?> _showDeleteDialog() {
    final bool isGoogle = AuthService.isGoogleUser;
    confirmationController.clear();
    passwordController.clear();
    bool isCorrectConfirmation = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Delete account?'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'This will permanently delete your account and all your transactions and categories. This action cannot be undone.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmationController,
                    decoration: const InputDecoration(
                      labelText: 'Type "confirm" to continue',
                    ),
                  ),
                  SizedBox(height: 8),
                  if (!isGoogle)
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                  if (!isCorrectConfirmation)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Invalid Input',
                        style: TextStyle(color: AppColors.expense, fontSize: 14),
                      ),
                    ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (confirmationController.text.trim().toLowerCase() ==
                            'confirm') {
                          Navigator.of(dialogContext).pop(passwordController.text);
                        } else {
                          setDialogState(() => isCorrectConfirmation = false);
                        }
                      },
                      child: Text(
                        'Delete Account',
                        style: TextStyle(color: AppColors.expense),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    setState(() => isClickedDeleteAccount = true);
    final String? password = await _showDeleteDialog();
    if (!mounted) return;

    if (password == null) {
      setState(() => isClickedDeleteAccount = false);
      return;
    }

    final bool ok = await AuthService.deleteAccount(password: password);
    if (!mounted) return;

    if (ok) {
      _goToLogin();
    } else {
      setState(() => isClickedDeleteAccount = false);
      Fluttertoast.showToast(
        msg: 'ERROR: could not delete account',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: AppColors.expenseContainer,
        textColor: AppColors.expense,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool busy = isClickedSignOut || isClickedDeleteAccount;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            InkWell(
              onTap: busy ? null : _logout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border, width: 1),
                  color: AppColors.primaryContainer,
                ),
                child: (isClickedSignOut)
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.logout, color: AppColors.primary),
                          SizedBox(width: 20),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: busy ? null : _deleteAccount,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border, width: 1),
                  color: AppColors.primaryContainer,
                ),
                child: (isClickedDeleteAccount)
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.delete_forever, color: AppColors.expense),
                          SizedBox(width: 20),
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              color: AppColors.expense,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
