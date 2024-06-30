import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models.dart';
import '../../../tools.dart';

class CharacterComicTile extends StatelessWidget {
  const CharacterComicTile({
    super.key,
    required this.characterComic,
  });

  final CharacterComic characterComic;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => launchUrl(Uri.parse(characterComic.urls.first.url)),
      child: Container(
        height: 160.sp,
        width: 100.sp,
        decoration: BoxDecoration(
          color: context.primaryColor[100],
          borderRadius: BorderRadius.circular(14.sp),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              characterComic.thumbnail.url,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
