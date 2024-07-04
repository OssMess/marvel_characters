import 'package:flutter/material.dart';

import '../../../../settings/settings_controller.dart';
import '../../../../data/enums.dart';
import '../../screens.dart';

class AuthenticationRouter extends StatefulWidget {
  const AuthenticationRouter({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<AuthenticationRouter> createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRouter> {
  late ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  void initState() {
    authRouteNotifier = ValueNotifier<AuthRoute>(AuthRoute.register);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authRouteNotifier,
      builder: (context, authRoute, _) {
        switch (authRoute) {
          case AuthRoute.register:
            return Register(
              authRouteNotifier: authRouteNotifier,
            );
          case AuthRoute.signin:
            return Signin(
              authRouteNotifier: authRouteNotifier,
            );
          default:
            throw UnimplementedError('AuthRoute switch case not handeled.');
        }
      },
    );
  }
}
