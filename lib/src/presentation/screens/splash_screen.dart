import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badge;

import '../../business_logic/cubits.dart';
import '../../tools.dart';
import '../../data/models_ui.dart';
import '../model_widgets.dart';

/// Splash screen, it shows when the app is opened and is still preparing data
class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.canSignOut,
    this.exception,
  });

  final bool canSignOut;
  final Exception? exception;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          children: [
            (context.viewPadding.top).height,
            1.sw.width,
            const Spacer(),
            if (exception == null) ...[
              Container(
                height: 330.sp,
                width: 330.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.sp),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 90.sp),
              const SpinKitCubeGrid(
                color: Colors.red,
              ),
            ],
            if (exception != null) ...[
              const Spacer(flex: 2),
              const Spacer(),
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
                  disappearanceFadeAnimationDuration:
                      Duration(milliseconds: 50),
                ),
                badgeContent: Icon(
                  Icons.bug_report,
                  size: 35.sp,
                  color: Styles.red,
                ),
                child: Icon(
                  Icons.warning_amber,
                  size: 90.sp,
                  color: context.primary,
                ),
              ),
              SizedBox(height: 40.sp),
              Text(
                AppLocalizations.of(context)!.oops,
                style: context.h2b1,
              ),
              SizedBox(height: 8.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.sp),
                child: Text(
                  Functions.of(context).translateException(exception!),
                  textAlign: TextAlign.center,
                  style: context.h5b3,
                ),
              ),
              const Spacer(flex: 3),
              if (canSignOut)
                CustomTextButton(
                  button: ModelTextButton(
                    label: AppLocalizations.of(context)!.logout,
                    onPressed: context.read<UserCubit>().signOut,
                    color: context.primaryColor,
                  ),
                ),
            ],
            const Spacer(),
            FutureBuilder(
              future: PackageInfo.fromPlatform().then((value) => value.version),
              builder: (context, snapshot) {
                return SizedBox(
                  height: 20.sp,
                  child: snapshot.hasData
                      ? Text(
                          'Version: ${snapshot.data!}',
                          style: context.h5b2,
                        )
                      : null,
                );
              },
            ),
            (context.viewPadding.bottom + 10.h).height,
          ],
        ),
      ),
    );
  }
}
