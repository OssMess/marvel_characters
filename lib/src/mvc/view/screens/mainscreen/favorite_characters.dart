import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../business_logic/cubits.dart';
import '../../../../tools.dart';
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
          return ListView.separated(
            padding: EdgeInsets.all(24.sp),
            itemCount: state.list.length,
            itemBuilder: (context, index) => BlocProvider(
              create: (context) => CharacterCubit(
                state.list.elementAt(index).state,
              ),
              child: const CharacterTile(),
            ),
            separatorBuilder: (_, __) => 30.height,
          );
        },
      ),
    );
  }
}
