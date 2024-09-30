import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackButton extends StatelessWidget {
  const BackButton({required BuildContext context, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset('assets/icon/jam_chevron_left.svg'),
      hoverColor: Color.fromRGBO(0, 0, 0, 0.05),
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: '뒤로가기',
    );
  }
}
