import 'package:bithabit/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerLink(
            label: 'Today',
          ),
          DrawerLink(
            label: 'Goals',
          ),
          DrawerLink(
            label: 'Summary',
          ),
          const SizedBox(height: 100),
          DrawerLink(
            label: 'Logout',
            onTap: () {
              context.read<Auth>().logout();
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
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            height: 2,
            color: danger ? Colors.red : null,
          ),
        ),
      ),
      // leading: const Icon(Icons.logout),
      onTap: onTap,
    );
  }
}
