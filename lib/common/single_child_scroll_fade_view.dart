import 'package:flutter/material.dart';

class FadeShaderMask extends StatelessWidget {
  const FadeShaderMask({
    super.key,
    required this.scrollController,
    this.topFadeHeight = 30,
    this.bottomFadeHeight = 30,
    this.child,
  });

  final ScrollController scrollController;
  final double topFadeHeight;
  final double bottomFadeHeight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        double scrollPosition =
            scrollController.hasClients ? scrollController.position.pixels : 0;
        double scrollViewHeight = scrollController.position.viewportDimension;
        double scrollPosition2 = scrollPosition + scrollViewHeight;
        double scrollExtentAfter = scrollController.position.extentAfter;
        double topStart = scrollPosition;
        double topEnd =
            topStart + (topStart > topFadeHeight ? topFadeHeight : topStart);
        double bottomEnd = scrollPosition2;
        double bottomStart = scrollPosition2 -
            (scrollExtentAfter > bottomFadeHeight
                ? bottomFadeHeight
                : scrollExtentAfter);
        double height = bounds.height;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [
            topStart / height,
            topEnd / height,
            bottomStart / height,
            bottomEnd / height,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}

class SingleChildScrollFadeView extends StatefulWidget {
  const SingleChildScrollFadeView({
    super.key,
    this.scrollController,
    this.topFadeHeight = 30,
    this.bottomFadeHeight = 30,
    this.child,
    this.physics,
  });

  final ScrollController? scrollController;
  final double topFadeHeight;
  final double bottomFadeHeight;
  final Widget? child;
  final ScrollPhysics? physics;

  @override
  State<SingleChildScrollFadeView> createState() =>
      _SingleChildScrollFadeViewState();
}

class _SingleChildScrollFadeViewState extends State<SingleChildScrollFadeView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: widget.physics,
      child: FadeShaderMask(
        scrollController: _scrollController!,
        topFadeHeight: widget.topFadeHeight,
        child: widget.child,
      ),
    );
  }
}
