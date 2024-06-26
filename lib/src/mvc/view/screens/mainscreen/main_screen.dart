import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../../main.dart';
import '../../../../settings/settings_controller.dart';
import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/list_models.dart';
import '../../../model/models.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.user,
    required this.settingsController,
  });

  final UserSession user;
  final SettingsController settingsController;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ListCharacters(limit: 10).initData(callGet: true);
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Dialogs.of(context).showAlertDialog(
              dialogState: DialogState.confirmation,
              subtitle: AppLocalizations.of(context)!.signout_hint,
              onContinue: () => Dialogs.of(context).runAsyncAction(
                future: widget.user.signOut,
              ),
              continueLabel: AppLocalizations.of(context)!.signout,
            ),
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              AwesomeIconsLight.arrow_right_from_bracket,
            ),
          ),
        ],
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
