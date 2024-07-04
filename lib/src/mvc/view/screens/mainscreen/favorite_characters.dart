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
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userSessionState) {
          return ListView.separated(
            padding: EdgeInsets.all(24.sp),
            itemCount:
                (userSessionState as UserSession).hiveCharacters.list.length,
            itemBuilder: (context, index) => BlocProvider.value(
              value: BlocProvider.of<UserCubit>(context),
              child: CharacterTile(
                character:
                    userSessionState.hiveCharacters.list.elementAt(index),
              ),
            ),
            separatorBuilder: (_, __) => 30.height,
          );
        },
      ),
    );
  }
}
