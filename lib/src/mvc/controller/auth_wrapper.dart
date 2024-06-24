import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../home.dart';
import '../../settings/settings_controller.dart';
import '../../tools.dart';
import '../model/models.dart';
import '../view/screens.dart';

/// This class is responsable for data flow down the widget tree as well as managing which widget is displayed including:
/// - `SplashScreen`: displayed when the data is still being prepared and the app is still not ready for use,
/// - `UpdateScreen`: displayed when the remote config indicates that there is a new update for the app
/// - `BreakScreen`: displayed when the remote config indicates that the app or our servers are under maintenance
/// - `MainScreen`: displayed when non of the above conditions are satisfied
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    super.key,
    required this.settingsController,
    required this.showSplashScreen,
    required this.hideSplashScreen,
  });

  /// settings controller
  final SettingsController settingsController;

  /// used to avoid rebuilding the splash screen, which may cause the animation to repeat multiple times
  final bool showSplashScreen;

  /// used to disable rebuilding the splash screen when the AuthWrapper rebuilds
  final void Function() hideSplashScreen;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late bool showSplashScreen;
  Set<String> imagesAssets = {};
  Set<String> svgAssets = {};

  @override
  void initState() {
    super.initState();
    showSplashScreen = widget.showSplashScreen;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      precacheImages(context);
      Paddings.init(context);
      Future.delayed(
        const Duration(seconds: 4),
        () {
          if (context.mounted) {
            setState(() {
              widget.hideSplashScreen();
              showSplashScreen = false;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAPISession>(
      builder: (context, userSession, _) {
        if (userSession.isAwaitingAuth || showSplashScreen) {
          return SplashScreen(
            exception: userSession.error,
          );
        }
        //For APIs
        // if (userSession.requiredInitAccountDetails) {
        //   return SplashScreen(
        //     userSession: userSession,
        //     isLoading: true,
        //     // error: (snapshot.error as BookingHeroException).message,
        //   );
        // }
        // if (userSession.requiredInitAccountDetails && snapshot.hasData) {
        //   userSession.updateFromMap(snapshot.data!);
        // }

        //For onboarding
        // if (widget.settingsController.showOnboarding) {
        //   return Onboarding(settingsController: widget.settingsController);
        // }

        // return MainScreen(
        //   user: userSession,
        // );
        return const Home();
      },
    );
  }

  /// add images in `imagesAssets` and `svgAssets` to cache for faster load times.
  Future<bool> precacheImages(BuildContext context) async {
    for (var imagePath in imagesAssets) {
      await precacheImage(AssetImage(imagePath), context);
    }
    imagesAssets.clear();
    for (var svgPath in svgAssets) {
      // ignore: use_build_context_synchronously
      await precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          svgPath,
        ),
        context.mounted ? context : null,
      );
    }
    svgAssets.clear();
    return true;
  }
}
