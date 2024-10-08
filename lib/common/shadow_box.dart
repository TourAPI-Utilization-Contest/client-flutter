import 'package:flutter/material.dart';

class ShadowBox extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final Color color;
  final bool supportExpansion;
  final double height;
  final double? expandedHeight;
  final void Function()? onPressed;
  const ShadowBox({
    required this.child,
    this.borderRadius = 8.0,
    this.color = Colors.white,
    this.supportExpansion = false,
    this.height = 100,
    this.expandedHeight,
    this.onPressed,
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
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      height: _isExpanded ? widget.expandedHeight ?? 200 : widget.height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        // onPressed: widget.onPressed,
        onPressed: () {
          if (widget.supportExpansion) {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: widget.child,
      ),
    );
  }
}
