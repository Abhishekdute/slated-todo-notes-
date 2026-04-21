import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class SlatedLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const SlatedLogo({
    super.key,
    this.size = 40,
    this.showText = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.premiumGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: size * 0.4,
                offset: Offset(0, size * 0.2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: size * 0.7,
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.3),
          Text(
            "Slated",
            style: TextStyle(
              fontSize: size * 0.7,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: color ?? AppColors.primary,
            ),
          ),
        ],
      ],
    );
  }
}
