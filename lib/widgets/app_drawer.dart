import 'package:bithabit/pages/auth_page.dart';
import 'package:bithabit/providers/auth.dart';
import 'package:bithabit/providers/sounds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // DrawerLink(
          //   label: 'Today',
          //   onTap: () {
          //     SystemSound.play(SystemSoundType.click);
          //     HapticFeedback.selectionClick();
          //   },
          // ),
          // DrawerLink(
          //   label: 'Goals',
          // ),
          // DrawerLink(
          //   label: 'Summary',
          // ),
          // const SizedBox(height: 100),
          // DrawerLink(
          //   label: ,
          // ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              context.read<Auth>().email ?? 'Unknown User',
            ),
          ),
          Divider(),
          DrawerLink(
            label: 'Logout',
            onTap: () {
              context.read<Auth>().logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AuthPage()));
            },
            danger: true,
          ),
        ],
      ),
    );
  }
}

class DrawerLink extends StatelessWidget {
  final String label;
  final void Function()? onTap;
  final bool danger;

  const DrawerLink(
      {Key? key, required this.label, this.onTap, this.danger = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: danger ? Colors.red : null,
          ),
        ),
      ),
      // leading: const Icon(Icons.logout),
      onTap: onTap,
    );
  }
}
