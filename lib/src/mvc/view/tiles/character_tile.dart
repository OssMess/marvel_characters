import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../model/models.dart';
import '../../../tools.dart';
import '../screens.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({
    super.key,
    required this.userSession,
    required this.character,
  });

  final UserSession userSession;
  final Character character;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => context.push(
        widget: CharacterDetails(
          userSession: userSession,
          character: character,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82.sp,
            height: 82.sp,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.sp),
              child: Hero(
                tag: 'character${character.id}',
                child: Image(
                  fit: BoxFit.cover,
                  image: character.photo,
                ),
              ),
            ),
          ),
          14.widthSp,
          Expanded(
            child: SizedBox(
              height: 82.sp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.h3b1,
                  ),
                  Text(
                    '#${character.id}',
                    style: context.h5b2,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleNumberFormater(
                        title: AppLocalizations.of(context)!.comics,
                        number: character.comics.items.length,
                      ),
                      TitleNumberFormater(
                        title: AppLocalizations.of(context)!.series,
                        number: character.series.items.length,
                      ),
                      TitleNumberFormater(
                        title: AppLocalizations.of(context)!.events,
                        number: character.events.items.length,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleNumberFormater extends StatelessWidget {
  const TitleNumberFormater({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final int number;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: context.h5b3,
          ),
          TextSpan(
            text: NumberFormat('#00').format(number),
            style: context.h5b2,
          ),
        ],
      ),
    );
  }
}
