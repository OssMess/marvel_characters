import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits.dart';
import '../../data/data_providers.dart';
import '../../settings/settings_controller.dart';
import '../../tools.dart';
import '../view/screens.dart';
import 'hives.dart';

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
    return StreamBuilder<User?>(
      stream: FirebaseAuthenticationRepository().onChangeAuthState(),
      builder: (context, snapshot) {
        // Awaiting auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        // Unauthenticated
        if (snapshot.data == null) {
          return AuthenticationRouter(
            settingsController: widget.settingsController,
          );
        }
        // Authenticated
        return FutureBuilder(
          future: FirebaseAuthenticationRepository.userFromFirebaseUser(
            FirebaseAuth.instance.currentUser!,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SplashScreen();
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider<UserSessionCubit>(
                  create: (context) =>
                      UserSessionCubit.fromUserSession(snapshot.data!),
                ),
                BlocProvider<ListCharactersCubit>(
                  create: (context) => ListCharactersCubit(HiveCharacters())
                    ..initData(callGet: true),
                ),
              ],
              child: MainScreen(
                settingsController: widget.settingsController,
              ),
            );
          },
        );
      },
    );
  }
}
