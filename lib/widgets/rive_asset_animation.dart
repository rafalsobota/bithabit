import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;

class RiveAssetAnimation extends StatefulWidget {
  final String asset;
  final String animation;
  final Widget? background;

  const RiveAssetAnimation(
      {Key? key, required this.asset, required this.animation, this.background})
      : super(key: key);

  @override
  _RiveAssetAnimationState createState() => _RiveAssetAnimationState();
}

class _RiveAssetAnimationState extends State<RiveAssetAnimation> {
  rive.Artboard? _riveArtboard;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () => rootBundle.load(widget.asset),
    ).then(
      (data) async {
        final file = rive.RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(rive.SimpleAnimation(widget.animation));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.background != null) widget.background!,
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _riveArtboard == null ? 0.0 : 1.0,
          child: _riveArtboard == null
              ? Container()
              : rive.Rive(
                  artboard: _riveArtboard!,
                  fit: BoxFit.cover,
                ),
        ),
      ],
    );
  }
}
