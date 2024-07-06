import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../business_logic/cubits.dart';
import '../../../tools.dart';
import '../../model_widgets.dart';
import '../../tiles.dart';

class CharacterDetails extends StatefulWidget {
  const CharacterDetails({
    super.key,
  });

  @override
  State<CharacterDetails> createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      context.read<CharacterCubit>().init(scrollController);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<ListCharactersBookmarkedCubit>().bookmark(
                      context.read<CharacterCubit>(),
                      context.read<ListCharactersCubit>(),
                    ),
            icon: BlocBuilder<CharacterCubit, CharacterState>(
              builder: (context, state) {
                return Icon(
                  (state as CharacterLoaded).isBookmarked
                      ? AwesomeIconsSolid.heart
                      : AwesomeIconsRegular.heart,
                );
              },
            ),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        CharacterLoaded character =
            context.read<CharacterCubit>().state as CharacterLoaded;
        return SingleChildScrollView(
          child: Column(
            children: [
              //Header
              SizedBox(
                width: 1.sw,
                height: 1.sw,
                child: Hero(
                  tag: 'character${character.id}',
                  child: Stack(
                    children: [
                      Image(
                        fit: BoxFit.cover,
                        image: character.photo,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [
                                0.0,
                                0.1,
                                0.6,
                                1,
                              ],
                              colors: [
                                context.b6,
                                Colors.transparent,
                                Colors.transparent,
                                context.b6,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Body
              Padding(
                padding: EdgeInsets.all(24.sp).add(
                  EdgeInsets.only(
                    bottom: context.viewPadding.bottom,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title/Name
                    Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    Text(
                      '#${character.id}',
                      style: context.h4b2,
                    ),
                    //Description
                    if (character.description.trim().isNotEmpty) ...[
                      30.heightSp,
                      Text(
                        AppLocalizations.of(context)!.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h2b1,
                      ),
                      Text(
                        character.description,
                        style: context.h4b2,
                      ),
                    ],
                    //Links
                    if (character.urls.isNotEmpty) ...[
                      16.heightSp,
                      Text(
                        AppLocalizations.of(context)!.links,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h2b1,
                      ),
                      if (character.hasDetailsUrl)
                        ReadMoreLink(
                          title: AppLocalizations.of(context)!.read_more_detail,
                          url: character.detailUrl,
                        ),
                      if (character.hasWikiUrl)
                        ReadMoreLink(
                          title: AppLocalizations.of(context)!.read_more_wiki,
                          url: character.wikiUrl,
                        ),
                      if (character.hasComicLinkUrl)
                        ReadMoreLink(
                          title: AppLocalizations.of(context)!
                              .read_more_comic_link,
                          url: character.comiclinkUrl,
                        ),
                    ],
                    //Comics
                    if (character.comics.items.isNotEmpty) ...[
                      30.heightSp,
                      Text(
                        '${AppLocalizations.of(context)!.comics} (${character.comics.items.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h2b1,
                      ),
                      UnconstrainedBox(
                        child: SizedBox(
                          height: 160.sp,
                          width: 1.sw,
                          child: BlocProvider.value(
                            value: character.listCharacterComicsCubit,
                            child: BlocBuilder<ListCharacterComicsCubit,
                                ListCharacterComicsState>(
                              builder: (context, listCharacterComics) {
                                if (listCharacterComics
                                        is ListCharacterComicsInitial ||
                                    listCharacterComics
                                        is ListCharacterComicsLoading) {
                                  return Center(
                                    child: SpinKitCubeGrid(
                                      size: 30.sp,
                                      color: Colors.red,
                                    ),
                                  );
                                }
                                if (listCharacterComics
                                    is ListCharacterComicsError) {
                                  return CustomErrorWidget(
                                    error: listCharacterComics.error,
                                    offset: 0.7,
                                  );
                                }
                                return ListView.separated(
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.sp),
                                  itemBuilder: (context, index) =>
                                      CharacterComicTile(
                                    characterComic:
                                        listCharacterComics.elementAt(index),
                                  ),
                                  separatorBuilder: (_, __) => 10.widthSp,
                                  itemCount: (listCharacterComics
                                          as ListCharacterComicsLoaded)
                                      .length,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ReadMoreLink extends StatelessWidget {
  const ReadMoreLink({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.sp),
      child: InkResponse(
        onTap: () => launchUrl(
          Uri.parse(url),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              AwesomeIconsLight.globe,
              color: Styles.red,
              size: 20.sp,
            ),
            6.widthSp,
            Text(
              title,
              style: context.h4b2.copyWith(color: Styles.red),
            ),
          ],
        ),
      ),
    );
  }
}
