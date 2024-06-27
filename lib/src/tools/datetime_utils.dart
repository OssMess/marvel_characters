import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DateTimeUtils {
  final BuildContext context;

  DateTimeUtils(this.context);

  static DateTimeUtils of(BuildContext context) {
    assert(context.mounted);
    return DateTimeUtils(context);
  }

  ///returns a `DateTime` from [value].
  ///
  ///If [value] is null:
  ///- if [initIfNull] is true: return `DateTime.now()`
  ///- else: return null
  static DateTime? getDateTimefromTimestamp(
    dynamic value, [
    bool initIfNull = true,
  ]) {
    try {
      if (value is Timestamp) {
        return DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000)
            .toLocal();
      } else if (value is DateTime) {
        return value;
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        throw Exception();
      }
    } on Exception {
      if (initIfNull) {
        return DateTime.now();
      } else {
        return null;
      }
    }
  }
}
