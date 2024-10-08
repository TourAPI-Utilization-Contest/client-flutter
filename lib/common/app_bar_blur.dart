import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AppBarBlur extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final CustomClipper<Path>? clipper;
  final Size _preferredSize;

  const AppBarBlur({
    super.key,
    required this.title,
    required ScrollController scrollController,
    this.clipper,
    Size preferredSize = const Size.fromHeight(kToolbarHeight),
  })  : _scrollController = scrollController,
        _preferredSize = preferredSize;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: clipper, //?? _AppBarClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: ListenableBuilder(
          listenable: _scrollController,
          builder: (context, _) => AppBar(
            title: title,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Color.lerp(
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withAlpha(0),
              min(
                  0.3,
                  _scrollController.hasClients
                      ? _scrollController.position.pixels / 300
                      : 0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => _preferredSize;
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width / 2, size.height, 0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
