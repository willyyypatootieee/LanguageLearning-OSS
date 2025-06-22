import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/core.dart';

/// Widget that represents a single navigation item with SVG icon.
class NavbarItem extends StatelessWidget {
  final String svgPath;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavbarItem({
    super.key,
    required this.svgPath,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppConstants.navbarHeight,
        height: AppConstants.navbarHeight,
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: AppConstants.navbarIconSize,
            height: AppConstants.navbarIconSize,
          ),
        ),
      ),
    );
  }
}
