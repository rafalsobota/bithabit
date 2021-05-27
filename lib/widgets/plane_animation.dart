import 'package:bithabit/widgets/rive_asset_animation.dart';
import 'package:flutter/material.dart';

class PlaneAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RiveAssetAnimation(
      asset: 'assets/animations/plane.riv',
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
