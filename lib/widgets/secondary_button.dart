import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final bool danger;

  const SecondaryButton(
      {Key? key, required this.label, this.onPressed, this.danger = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white70,
        primary: danger ? Colors.red : null,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
