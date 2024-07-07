import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/_models.dart';

part 'comic_state.dart';

class ComicCubit extends Cubit<ComicState> {
  ComicCubit(ComicState comicState) : super(comicState);

  factory ComicCubit.fromJson(Map<String, dynamic> json) => ComicCubit(
        ComicLoaded.fromJson(json),
      );
}
