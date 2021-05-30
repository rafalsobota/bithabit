import 'package:bithabit/widgets/rive_asset_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

bool isMobileWeb(BuildContext context) {
  return kIsWeb &&
      (Theme.of(context).platform == TargetPlatform.iOS ||
          Theme.of(context).platform == TargetPlatform.android);
}

class PlaneAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RiveAssetAnimation(
      asset: isMobileWeb(context)
          ? 'assets/animations/plane_simple.riv'
          : 'assets/animations/plane.riv',
      animation: 'Animation 1',
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xff9e3c3c), Color(0xffeccc65)],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
