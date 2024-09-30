import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget? trailing;
  const Section({
    required this.title,
    required this.content,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title,
              if (trailing != null) trailing!,
            ],
          ),
          content,
        ],
      ),
    );
  }
}

class SectionLegacy extends StatelessWidget {
  final String title;
  final Widget content;
  const SectionLegacy({
    required String this.title,
    required Widget this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: content,
        ),
      ],
    );
  }
}
