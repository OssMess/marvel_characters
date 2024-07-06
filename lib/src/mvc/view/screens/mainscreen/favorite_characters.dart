import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../business_logic/cubits.dart';
import '../../../../tools.dart';
import '../../model_widgets.dart';
import '../../tiles.dart';

class FavoriteCharacters extends StatelessWidget {
  const FavoriteCharacters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ListCharactersBookmarkedCubit,
          ListCharactersBookmarkedState>(
        builder: (context, state) {
          if (state is ListCharactersBookmarkedInitial ||
              state is ListCharactersBookmarkedLoading) {
            return Center(
              child: SpinKitCubeGrid(
                size: 35.sp,
                color: Colors.red,
              ),
            );
          }
          if (state is ListCharactersBookmarkedError) {
            return CustomErrorWidget(
              error: state.error,
            );
          }
          state as ListCharactersBookmarkedLoaded;
          return ListView.separated(
            padding: EdgeInsets.all(24.sp),
            itemCount: state.set.length,
            itemBuilder: (context, index) => Builder(builder: (context) {
              CharacterCubit character = state.set.elementAt(index);
              return BlocProvider.value(
                value: character,
                child: CharacterTile(
                  key: ValueKey((character.state as CharacterLoaded).id),
                ),
              );
            }),
            separatorBuilder: (_, __) => 30.height,
          );
        },
      ),
    );
  }
}
