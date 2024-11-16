import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/provider/logout_provider.dart';

class SettingPage extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingPage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0E5E5),
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ListTile(
                title: const Text("Logout"),
                subtitle: const Text("Click for logout account"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  await Provider.of<LogoutProvider>(context,
                                          listen: false)
                                      .logoutAccount();
                                  onLogout();
                                  if (context.mounted) Navigator.pop(context);
                                },
                                child: const Text("Logout")),
                          ],
                        );
                      });
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
