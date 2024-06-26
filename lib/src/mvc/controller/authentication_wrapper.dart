import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_controller.dart';
import '../../tools.dart';
import '../model/models.dart';
import '../view/screens.dart';

/// This class is responsable for data flow down the widget tree as well as managing which widget is displayed including:
/// - `SplashScreen`: displayed when the data is still being prepared and the app is still not ready for use,
/// - `UpdateScreen`: displayed when the remote config indicates that there is a new update for the app
/// - `BreakScreen`: displayed when the remote config indicates that the app or our servers are under maintenance
/// - `MainScreen`: displayed when non of the above conditions are satisfied
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({
    super.key,
    required this.settingsController,
  });

  /// settings controller
  final SettingsController settingsController;

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      Paddings.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSession>(
      builder: (context, userSession, _) {
        if (userSession.isAwaiting) {
          return SplashScreen(
            userSession: userSession,
            exception: userSession.error,
          );
        }
        if (userSession.isUnauthenticated) {
          return AuthenticationRouter(
            userSession: userSession,
            settingsController: widget.settingsController,
          );
        }
        return MainScreen(
          user: userSession,
          settingsController: widget.settingsController,
        );
      },
    );
  }
}
