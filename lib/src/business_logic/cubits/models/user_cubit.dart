import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/enums.dart';
import '../../../mvc/controller/services.dart';
import '../../../tools/datetime_utils.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit([UserState? userState]) : super(userState ?? const UserLoading());

  Future<void> signOut() async {
    assert(
        state is UserLoaded, 'UserState must be UserSession to call signOut.');
    await (state as UserLoaded).signOut();
    // can not emit a new state after this cubit is closed in the authwrapper
    // once signed out (no longer needed in the widget tree)
    // emit(const UserUnAuthenticated());
  }

  void emitUserLoading() => emit(const UserLoading());

  Future<void> listenAuthStateChanges() async {
    FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        if (user == null) {
          // user is not connected
          emit(const UserUnAuthenticated());
        } else {
          // user is connected
          try {
            emit(
              await FirebaseAuthenticationRepository.userFromFirebaseUser(user),
            );
          } on Exception catch (e) {
            // an error has occured
            emit(UserUnAuthenticated(e));
          }
        }
      },
    );
  }
}
