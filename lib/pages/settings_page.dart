import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/pages/login_register_page.dart';
import 'package:pocket_flow/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isClickedSignOut;
  @override
  void initState() {
    super.initState();
    isClickedSignOut = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  isClickedSignOut = true;
                });
                final result = await AuthService.signOutUser();
                if (result) {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const LoginRegisterPage()),
                  );
                } else {
                  setState(() {
                    isClickedSignOut = false;
                  });
                }
              },
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
          ],
        ),
      ),
    );
  }
}
