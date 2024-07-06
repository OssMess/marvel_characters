import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business_logic/cubits.dart';
import '../settings/settings_controller.dart';
import '../tools.dart';
import 'screens.dart';

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
  late ListCharactersBookmarkedCubit listCharactersBookmarkedCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      listCharactersBookmarkedCubit =
          ListCharactersBookmarkedCubit(ListCharactersBookmarkedInitial());
      listCharactersBookmarkedCubit.init();
      Paddings.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        // Awaiting auth state
        if (userState is UserLoading) {
          return const SplashScreen(
            canSignOut: false,
          );
        }
        // Unauthenticated
        if (userState is UserUnAuthenticated) {
          if (userState.error != null) {
            return SplashScreen(
              canSignOut: true,
              exception: userState.error,
            );
          }
          return AuthenticationRouter(
            settingsController: widget.settingsController,
          );
        }
        // Authenticated
        return MultiBlocProvider(
          providers: [
            BlocProvider<ListCharactersBookmarkedCubit>.value(
              value: listCharactersBookmarkedCubit,
              // lazy: false,
              // create: (context) =>
              //     ListCharactersBookmarkedCubit(listCharactersBookmarkedCubit)
              // ..init(),
            ),
            BlocProvider<ListCharactersCubit>(
              create: (context) =>
                  ListCharactersCubit(listCharactersBookmarkedCubit)
                    ..initData(callGet: true),
            ),
          ],
          child: MainScreen(
            settingsController: widget.settingsController,
          ),
        );
      },
    );
  }
}
