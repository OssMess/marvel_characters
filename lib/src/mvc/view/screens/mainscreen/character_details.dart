import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/list_models.dart';
import '../../../model/models.dart';
import '../../../../tools.dart';
import '../../tiles.dart';

class CharacterDetails extends StatefulWidget {
  const CharacterDetails({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  State<CharacterDetails> createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.character.listCharacterComics
        .addControllerListener(scrollController);
    widget.character.listCharacterComics.initData(callGet: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          AnimatedBuilder(
            animation: widget.character,
            builder: (context, _) {
              return IconButton(
                onPressed: widget.character.bookmark,
                icon: Icon(
                  widget.character.isBookmarked
                      ? AwesomeIconsSolid.heart
                      : AwesomeIconsRegular.heart,
                ),
              );
            },
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
                tag: 'character${widget.character.id}',
                child: Stack(
                  children: [
                    Image(
                      fit: BoxFit.cover,
                      image: widget.character.photo,
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
                    widget.character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.h2b1,
                  ),
                  Text(
                    '#${widget.character.id}',
                    style: context.h4b2,
                  ),
                  //Description
                  if (widget.character.description.trim().isNotEmpty) ...[
                    30.heightSp,
                    Text(
                      AppLocalizations.of(context)!.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    Text(
                      widget.character.description,
                      style: context.h4b2,
                    ),
                  ],
                  //Links
                  if (widget.character.urls.isNotEmpty) ...[
                    16.heightSp,
                    Text(
                      AppLocalizations.of(context)!.links,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    if (widget.character.hasDetailsUrl)
                      ReadMoreLink(
                        title: AppLocalizations.of(context)!.read_more_detail,
                        url: widget.character.detailUrl,
                      ),
                    if (widget.character.hasWikiUrl)
                      ReadMoreLink(
                        title: AppLocalizations.of(context)!.read_more_wiki,
                        url: widget.character.wikiUrl,
                      ),
                    if (widget.character.hasComicLinkUrl)
                      ReadMoreLink(
                        title:
                            AppLocalizations.of(context)!.read_more_comic_link,
                        url: widget.character.comiclinkUrl,
                      ),
                  ],
                  //Comics
                  if (widget.character.comics.items.isNotEmpty) ...[
                    30.heightSp,
                    Text(
                      '${AppLocalizations.of(context)!.comics} (${widget.character.comics.items.length})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.h2b1,
                    ),
                    UnconstrainedBox(
                      child: SizedBox(
                        height: 160.sp,
                        width: 1.sw,
                        child: ChangeNotifierProvider.value(
                          value: widget.character.listCharacterComics,
                          child: Consumer<ListCharacterComics>(
                            builder: (context, listCharacterComics, _) {
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
            // if (widget.character.comics.items.isNotEmpty) ...[

            // ],
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
