import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/enums.dart';
import '../../../data/models.dart';

part 'user_session_state.dart';

class UserSessionCubit extends Cubit<UserSessionState> {
  factory UserSessionCubit(UserSessionState userSessionState) =>
      UserSessionCubit(userSessionState);

  factory UserSessionCubit.fromUserSession(UserSession userSession) =>
      UserSessionCubit(UserSessionAuthenticated(userSession: userSession));

  Future<void> signOut() async {
    await state.userSession.signOut();
    emit(UserSessionUnauthenticated());
  }
}
