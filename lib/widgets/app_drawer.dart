import 'package:bithabit/pages/auth_page.dart';
import 'package:bithabit/providers/auth.dart';
import 'package:bithabit/providers/sounds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = context.watch<Auth>().email ?? '';
    final nick = email.split('@')[0];
    return Drawer(
      child: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Bithabit',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          Divider(),
          DrawerLink(label: nick, icon: Icons.account_circle_outlined),
          Divider(),
          DrawerLink(
            icon: Icons.logout,
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
  final IconData? icon;

  const DrawerLink(
      {Key? key,
      required this.label,
      this.onTap,
      this.icon,
      this.danger = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                icon,
                color: danger ? Colors.red.shade300 : null,
              ),
            ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
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
