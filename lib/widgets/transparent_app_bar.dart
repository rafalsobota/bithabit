import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget {
  const TransparentAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(Icons.menu),
      ),
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
    );
    // return Container(
    //   width: double.infinity,
    //   alignment: Alignment.topLeft,
    //   child: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.only(left: 16.0),
    //       child: IconButton(
    //         icon: Icon(
    //           Icons.menu,
    //           color: Theme.of(context).brightness == Brightness.light
    //               ? Colors.black45
    //               : Colors.white54,
    //         ),
    //         onPressed: () {
    //           Scaffold.of(context).openDrawer();
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
