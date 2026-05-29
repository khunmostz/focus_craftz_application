import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeskIllustration extends StatelessWidget {
  const DeskIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/desk_illustration.svg',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
