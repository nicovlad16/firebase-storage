import 'package:intl/intl.dart';

import '../common/index.dart';
import '../storage/hmacKey.dart';

typedef RequestCallback = void Function(DecorateRequestOptions reqOpts, BodyResponseCallback callback);

typedef OnUploadProgressCallback = void Function(dynamic progressEvent);

typedef GetAclCallback = void Function(Exception? err, HmacKeyMetadata? metadata, Metadata? apiResponse);

const int SEVEN_DAYS = 7 * 24 * 60 * 60;

int parseExpires(dynamic expires /* string | number | Date */, {DateTime? current}) {
  current = current ?? DateTime.now();

  if (expires.runtimeType == String) {
    try {
      expires = DateTime.parse(expires);
    } catch (e) {
      throw 'The expiration date provided was invalid.';
    }
  } else if (expires.runtimeType == int) {
    expires = DateTime(0).add(Duration(milliseconds: expires));
  } else if (expires.runtimeType != DateTime) {
    throw 'The expiration date provided was invalid.';
  }

  if (expires.isBefore(current)) {
    throw 'An expiration date cannot be in the past.';
  }

  return (expires.millisecondsSinceEpoch / 1000).floor(); // The API expects seconds.
}

int parseAccessibleAt(dynamic accessibleAt /* string | number | Date */) {
  accessibleAt = accessibleAt ?? DateTime.now();

  if (accessibleAt.runtimeType == String) {
    try {
      accessibleAt = DateTime.parse(accessibleAt);
    } catch (e) {
      throw 'The accessible at date provided was invalid.';
    }
  } else if (accessibleAt.runtimeType == int) {
    accessibleAt = DateTime(0).add(Duration(milliseconds: accessibleAt));
  } else if (accessibleAt.runtimeType != DateTime) {
    throw 'The accessible at date provided was invalid.';
  }

  return (accessibleAt.millisecondsSinceEpoch / 1000).floor(); // The API expects seconds.
}

String formatDate(dynamic date, String format, {bool utc = true}) {
  if (date is int) {
    date = DateTime(0).add(Duration(seconds: date));
  }
  if (date is String) {
    date = DateTime.parse(date);
  }
  // todo - finish date format converter
  DateTime dateTime = date as DateTime;
  if (utc) {
    dateTime = dateTime.toUtc();
  }
  final DateFormat dateFormat = DateFormat(format);
  return dateFormat.format(dateTime);
}
