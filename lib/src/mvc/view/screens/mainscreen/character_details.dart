import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../business_logic/cubits.dart';
import '../../../../data/list_models.dart';
import '../../../../data/models.dart';
import '../../../../tools.dart';
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
      BlocProvider.of<CharacterCubit>(context).init(scrollController);
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
            onPressed: () => BlocProvider.of<CharacterCubit>(context).bookmark(
              (BlocProvider.of<UserCubit>(context).state as UserSession)
                  .hiveCharacters,
            ),
            icon: BlocBuilder<CharacterCubit, CharacterState>(
              builder: (context, state) {
                return Icon(
                  state.isBookmarked
                      ? AwesomeIconsSolid.heart
                      : AwesomeIconsRegular.heart,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Header
            SizedBox(
              width: 1.sw,
              height: 1.sw,
              child: Hero(
                tag:
                    'character${BlocProvider.of<CharacterCubit>(context).state.id}',
                child: Stack(
                  children: [
                    Image(
                      fit: BoxFit.cover,
                      image:
                          BlocProvider.of<CharacterCubit>(context).state.photo,
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
                    BlocProvider.of<CharacterCubit>(context).state.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.h2b1,
                  ),
                  Text(
                    '#${BlocProvider.of<CharacterCubit>(context).state.id}',
                    style: context.h4b2,
                  ),
                  //Description
                  if (BlocProvider.of<CharacterCubit>(context)
                      .state
                      .description
                      .trim()
                      .isNotEmpty) ...[
                    30.heightSp,
                    Text(
                      AppLocalizations.of(context)!.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    Text(
                      BlocProvider.of<CharacterCubit>(context)
                          .state
                          .description,
                      style: context.h4b2,
                    ),
                  ],
                  //Links
                  if (BlocProvider.of<CharacterCubit>(context)
                      .state
                      .urls
                      .isNotEmpty) ...[
                    16.heightSp,
                    Text(
                      AppLocalizations.of(context)!.links,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    if (BlocProvider.of<CharacterCubit>(context)
                        .state
                        .hasDetailsUrl)
                      ReadMoreLink(
                        title: AppLocalizations.of(context)!.read_more_detail,
                        url: BlocProvider.of<CharacterCubit>(context)
                            .state
                            .detailUrl,
                      ),
                    if (BlocProvider.of<CharacterCubit>(context)
                        .state
                        .hasWikiUrl)
                      ReadMoreLink(
                        title: AppLocalizations.of(context)!.read_more_wiki,
                        url: BlocProvider.of<CharacterCubit>(context)
                            .state
                            .wikiUrl,
                      ),
                    if (BlocProvider.of<CharacterCubit>(context)
                        .state
                        .hasComicLinkUrl)
                      ReadMoreLink(
                        title:
                            AppLocalizations.of(context)!.read_more_comic_link,
                        url: BlocProvider.of<CharacterCubit>(context)
                            .state
                            .comiclinkUrl,
                      ),
                  ],
                  //Comics
                  if (BlocProvider.of<CharacterCubit>(context)
                      .state
                      .comics
                      .items
                      .isNotEmpty) ...[
                    30.heightSp,
                    Text(
                      '${AppLocalizations.of(context)!.comics} (${BlocProvider.of<CharacterCubit>(context).state.comics.items.length})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    UnconstrainedBox(
                      child: SizedBox(
                        height: 160.sp,
                        width: 1.sw,
                        child: BlocProvider.value(
                          value: BlocProvider.of<CharacterCubit>(context)
                              .state
                              .listCharacterComicsCubit,
                          child: BlocBuilder<ListCharacterComicsCubit,
                              ListCharacterComics>(
                            builder: (context, listCharacterComics) {
                              if (listCharacterComics.isNull &&
                                  listCharacterComics.isLoading) {
                                return Center(
                                  child: SpinKitCubeGrid(
                                    size: 30.sp,
                                    color: Colors.red,
                                  ),
                                );
                              }
                              return ListView.separated(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 24.sp),
                                itemBuilder: (context, index) {
                                  CharacterComic characterComic =
                                      listCharacterComics.elementAt(index);
                                  return CharacterComicTile(
                                      characterComic: characterComic);
                                },
                                separatorBuilder: (_, __) => 10.widthSp,
                                itemCount: listCharacterComics.length,
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
      ),
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
