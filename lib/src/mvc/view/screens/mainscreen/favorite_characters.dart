import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models.dart';
import '../../../../tools.dart';
import '../../tiles.dart';

class FavoriteCharacters extends StatelessWidget {
  const FavoriteCharacters({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        padding: EdgeInsets.all(24.sp),
        itemBuilder: (context, index) => CharacterTile(
          userSession: userSession,
          character: userSession.hiveCharacters!.list.elementAt(index),
        ),
        separatorBuilder: (_, __) => 30.height,
        itemCount: userSession.hiveCharacters!.list.length,
      ),
    );
  }
}
