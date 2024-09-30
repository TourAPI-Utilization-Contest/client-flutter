import 'package:flutter/material.dart';

class ShadowBox extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final Color color;
  final bool supportExpansion;
  final double height;
  final double? expandedHeight;
  const ShadowBox({
    required this.child,
    this.borderRadius = 8.0,
    this.color = Colors.white,
    this.supportExpansion = false,
    this.height = 100,
    this.expandedHeight,
    super.key,
  });

  @override
  State<ShadowBox> createState() => _ShadowBoxState();
}

class _ShadowBoxState extends State<ShadowBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        height: _isExpanded ? 200 : 119,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
