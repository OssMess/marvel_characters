import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/models.dart';

class UserSessionCubit extends Cubit<UserSession> {
  UserSessionCubit() : super(UserSession.init());
}
