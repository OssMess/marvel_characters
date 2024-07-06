import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../main.dart';
import '../../../../business_logic/cubits.dart';
import '../../../../settings/settings_controller.dart';
import '../../../../tools.dart';
import '../../../../data/enums.dart';
import '../../model_widgets.dart';
import '../../screens.dart';
import '../../tiles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message == null) return;
      log('getInitialMessage');
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        if (!kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@drawable/logo_notif',
                channelShowBadge: true,
                importance: Importance.max,
                playSound: true,
                priority: Priority.max,
                visibility: NotificationVisibility.public,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onOpenMessage(
        message.data['key'],
        message.data,
        true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: context.read<ListCharactersCubit>().onMaxScrollExtent,
      child: Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
          onRefresh: context.read<ListCharactersCubit>().refresh,
          color: context.primary,
          backgroundColor: context.primaryColor.shade50,
          displacement: context.viewPadding.top + 56,
          child: CustomScrollView(
            // physics: const ClampingScrollPhysics(),
            slivers: [
              //Header
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 1.77,
                  child: Container(
                    width: 1.sw,
                    alignment: AlignmentDirectional.topEnd,
                    padding: EdgeInsets.symmetric(horizontal: 8.sp).add(
                      EdgeInsets.only(
                        top: context.viewPadding.top,
                      ),
                    ),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/mcu.jpg'),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => context.push(
                            widget: MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<UserCubit>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<ListCharactersCubit>(),
                                ),
                                BlocProvider.value(
                                  value: context
                                      .read<ListCharactersBookmarkedCubit>(),
                                ),
                              ],
                              child: const FavoriteCharacters(),
                            ),
                          ),
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            AwesomeIconsSolid.heart,
                            color: context.b1,
                          ),
                        ),
                        14.widthSp,
                        IconButton(
                          onPressed: () => Dialogs.of(context).showAlertDialog(
                            dialogState: DialogState.confirmation,
                            subtitle:
                                AppLocalizations.of(context)!.signout_hint,
                            onContinue: () =>
                                Dialogs.of(context).runAsyncAction(
                              future: context.read<UserCubit>().signOut,
                            ),
                            continueLabel:
                                AppLocalizations.of(context)!.signout,
                          ),
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            AwesomeIconsLight.arrow_right_from_bracket,
                            color: context.b1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<ListCharactersCubit, ListCharactersState>(
                builder: (context, listCharacters) {
                  if (listCharacters is ListCharactersInitial ||
                      listCharacters is ListCharactersLoading) {
                    return SliverPadding(
                      padding: EdgeInsets.only(top: 200.h),
                      sliver: SliverToBoxAdapter(
                        child: SpinKitCubeGrid(
                          size: 35.sp,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  if (listCharacters is ListCharactersError) {
                    return SliverPadding(
                      padding: EdgeInsets.only(top: 100.h),
                      sliver: SliverToBoxAdapter(
                        child: CustomErrorWidget(
                          error: listCharacters.error,
                        ),
                      ),
                    );
                  }
                  if (listCharacters is ListCharactersLoaded) {
                    return SliverPadding(
                      padding: EdgeInsets.all(24.sp),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          if (index < listCharacters.length) {
                            CharacterCubit character =
                                listCharacters.elementAt(index);
                            return BlocProvider<CharacterCubit>.value(
                              value: character,
                              child: CharacterTile(
                                key: ValueKey(
                                    (character.state as CharacterLoaded).id),
                              ),
                            );
                          }
                          return CustomTrailingTile(
                            hasMore: listCharacters.hasMore,
                            isLoading: listCharacters.isLoading,
                            isNotNull: true,
                            isSliver: false,
                          );
                        },
                        separatorBuilder: (_, __) => 30.height,
                        itemCount: listCharacters.length +
                            (listCharacters.hasMore ? 1 : 0),
                      ),
                    );
                  }
                  throw UnimplementedError();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onBackgroundMessage(RemoteMessage message) async {
    log('onBackgroundMessage->${message.data}');
  }

  ///Trigger this code when a new message is recieved, without clicking on it
  void onMessage(RemoteMessage message) {
    log('onMessage->${message.data}');
    switch (message.data['key']) {
      default:
    }
  }

  Future<void> onOpenMessage(
    String key,
    Map<String, dynamic> data, [
    bool isOnFirstRoot = true,
    void Function(Exception)? onError,
  ]) async {
    try {
      FocusScope.of(context).unfocus();
      if (isOnFirstRoot) Navigator.popUntil(context, (route) => route.isFirst);
      switch (key) {
        default:
          return;
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'document-not-found':
          context.showSnackBar(
            'document_not_found',
          );
          // appNotification.delete();
          break;
        default:
          rethrow;
      }
    } on Exception {
      context.showSnackBar(
        'unknown_error',
      );
    }
  }
}
