import '../models.dart';

class Comic {
  final int code;
  final String status;
  final String copyright;
  final String attributionText;
  final String attributionHtml;
  final Data data;
  final String etag;

  Comic({
    required this.code,
    required this.status,
    required this.copyright,
    required this.attributionText,
    required this.attributionHtml,
    required this.data,
    required this.etag,
  });

  factory Comic.fromJson(Map<dynamic, dynamic> json) => Comic(
        code: json['code'],
        status: json['status'],
        copyright: json['copyright'],
        attributionText: json['attributionText'],
        attributionHtml: json['attributionHTML'],
        data: Data.fromJson(json['data']),
        etag: json['etag'],
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'copyright': copyright,
        'attributionText': attributionText,
        'attributionHTML': attributionHtml,
        'data': data.toJson(),
        'etag': etag,
      };
}

class Data {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Result> results;

  Data({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        offset: json['offset'],
        limit: json['limit'],
        total: json['total'],
        count: json['count'],
        results:
            List<Result>.from(json['results'].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'limit': limit,
        'total': total,
        'count': count,
        'results': List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  final int id;
  final int digitalId;
  final String title;
  final String issueNumber;
  final String variantDescription;
  final String description;
  final String modified;
  final String isbn;
  final String upc;
  final String diamondCode;
  final String ean;
  final String issn;
  final String format;
  final int pageCount;
  final List<TextObject> textObjects;
  final String resourceUri;
  final List<Url> urls;
  final Series series;
  final List<Series> variants;
  final List<Series> collections;
  final List<Series> collectedIssues;
  final List<Date> dates;
  final List<Price> prices;
  final Thumbnail thumbnail;
  final List<Thumbnail> images;
  final Characters creators;
  final Characters characters;
  final Stories stories;
  final Events events;

  Result({
    required this.id,
    required this.digitalId,
    required this.title,
    required this.issueNumber,
    required this.variantDescription,
    required this.description,
    required this.modified,
    required this.isbn,
    required this.upc,
    required this.diamondCode,
    required this.ean,
    required this.issn,
    required this.format,
    required this.pageCount,
    required this.textObjects,
    required this.resourceUri,
    required this.urls,
    required this.series,
    required this.variants,
    required this.collections,
    required this.collectedIssues,
    required this.dates,
    required this.prices,
    required this.thumbnail,
    required this.images,
    required this.creators,
    required this.characters,
    required this.stories,
    required this.events,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'],
        digitalId: json['digitalId'],
        title: json['title'],
        issueNumber: json['issueNumber'],
        variantDescription: json['variantDescription'],
        description: json['description'],
        modified: json['modified'],
        isbn: json['isbn'],
        upc: json['upc'],
        diamondCode: json['diamondCode'],
        ean: json['ean'],
        issn: json['issn'],
        format: json['format'],
        pageCount: json['pageCount'],
        textObjects: List<TextObject>.from(
            json['textObjects'].map((x) => TextObject.fromJson(x))),
        resourceUri: json['resourceURI'],
        urls: List<Url>.from(json['urls'].map((x) => Url.fromJson(x))),
        series: Series.fromJson(json['series']),
        variants:
            List<Series>.from(json['variants'].map((x) => Series.fromJson(x))),
        collections: List<Series>.from(
            json['collections'].map((x) => Series.fromJson(x))),
        collectedIssues: List<Series>.from(
            json['collectedIssues'].map((x) => Series.fromJson(x))),
        dates: List<Date>.from(json['dates'].map((x) => Date.fromJson(x))),
        prices: List<Price>.from(json['prices'].map((x) => Price.fromJson(x))),
        thumbnail: Thumbnail.fromJson(json['thumbnail']),
        images: List<Thumbnail>.from(
            json['images'].map((x) => Thumbnail.fromJson(x))),
        creators: Characters.fromJson(json['creators']),
        characters: Characters.fromJson(json['characters']),
        stories: Stories.fromJson(json['stories']),
        events: Events.fromJson(json['events']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'digitalId': digitalId,
        'title': title,
        'issueNumber': issueNumber,
        'variantDescription': variantDescription,
        'description': description,
        'modified': modified,
        'isbn': isbn,
        'upc': upc,
        'diamondCode': diamondCode,
        'ean': ean,
        'issn': issn,
        'format': format,
        'pageCount': pageCount,
        'textObjects': List<dynamic>.from(textObjects.map((x) => x.toJson())),
        'resourceURI': resourceUri,
        'urls': List<dynamic>.from(urls.map((x) => x.toJson())),
        'series': series.toJson(),
        'variants': List<dynamic>.from(variants.map((x) => x.toJson())),
        'collections': List<dynamic>.from(collections.map((x) => x.toJson())),
        'collectedIssues':
            List<dynamic>.from(collectedIssues.map((x) => x.toJson())),
        'dates': List<dynamic>.from(dates.map((x) => x.toJson())),
        'prices': List<dynamic>.from(prices.map((x) => x.toJson())),
        'thumbnail': thumbnail.toJson(),
        'images': List<dynamic>.from(images.map((x) => x.toJson())),
        'creators': creators.toJson(),
        'characters': characters.toJson(),
        'stories': stories.toJson(),
        'events': events.toJson(),
      };
}

class Date {
  final String type;
  final String date;

  Date({
    required this.type,
    required this.date,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        type: json['type'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date,
      };
}

class Events {
  final int available;
  final int returned;
  final String collectionUri;
  final List<Series> items;

  Events({
    required this.available,
    required this.returned,
    required this.collectionUri,
    required this.items,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        available: json['available'],
        returned: json['returned'],
        collectionUri: json['collectionURI'],
        items: List<Series>.from(json['items'].map((x) => Series.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'available': available,
        'returned': returned,
        'collectionURI': collectionUri,
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Price {
  final String type;
  final num price;

  Price({
    required this.type,
    required this.price,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        type: json['type'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'price': price,
      };
}

class TextObject {
  final String type;
  final String language;
  final String text;

  TextObject({
    required this.type,
    required this.language,
    required this.text,
  });

  factory TextObject.fromJson(Map<String, dynamic> json) => TextObject(
        type: json['type'],
        language: json['language'],
        text: json['text'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'language': language,
        'text': text,
      };
}
