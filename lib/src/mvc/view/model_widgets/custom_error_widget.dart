import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badge;

import '../../../data/models.dart';
import '../../../tools.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.error,
    this.offset = 1,
  });

  final BackendException error;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        badge.Badge(
          badgeStyle: const badge.BadgeStyle(
            badgeColor: Colors.transparent,
            elevation: 0,
          ),
          position: badge.BadgePosition.topEnd(
            top: -8.sp,
            end: -8.sp,
          ),
          badgeAnimation: const badge.BadgeAnimation.scale(
            animationDuration: Duration(milliseconds: 100),
            disappearanceFadeAnimationDuration: Duration(milliseconds: 50),
          ),
          badgeContent: Icon(
            Icons.bug_report,
            size: 35.sp * offset,
            color: Styles.red,
          ),
          child: Icon(
            Icons.warning_amber,
            size: 90.sp * offset,
            color: context.primary,
          ),
        ),
        (30 * offset).heightH,
        Text(
          '${AppLocalizations.of(context)!.oops} (${error.statusCode})',
          style: context.h2b1.copyWith(
            fontSize: (22 * offset).sp,
          ),
        ),
        (8 * offset).heightH,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: (25 * offset).sp),
          child: Text(
            error.code ?? AppLocalizations.of(context)!.unknown_error,
            textAlign: TextAlign.center,
            style: context.h5b3,
          ),
        ),
      ],
    );
  }
}
