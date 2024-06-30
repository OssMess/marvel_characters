import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models.dart';

class ComicCubit extends Cubit<Comic> {
  ComicCubit(Map<dynamic, dynamic> json) : super(Comic.fromJson(json));
}
