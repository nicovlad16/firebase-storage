import 'dart:convert';

String fixedEncodeURIComponent(String str) {
  return Uri.encodeComponent(str);
}

/// URI encode `uri` for generating signed URLs, using fixedEncodeURIComponent.
///
/// Encode every byte except `A-Z a-Z 0-9 ~ - . _`.
///
/// @param {string} uri The URI to encode.
/// @param [boolean=false] encodeSlash If `true`, the "/" character is not encoded.
/// @return {string} The encoded string.
String encodeURI(String uri, bool encodeSlash) {
// Split the string by `/`, and conditionally rejoin them with either
// %2F if encodeSlash is `true`, or '/' if `false`.
  return uri
      .split('/') //
      .map<String>(fixedEncodeURIComponent) //
      .join(encodeSlash ? '%2F' : '/');
}

/// Serialize an object to a URL query string using util.encodeURI(uri, true).
/// @param {string} url The object to serialize.
/// @return {string} Serialized string.
String qsStringify(Map<String, dynamic> query) {
  final jsonEncoder = JsonEncoder();
  final jsonString = jsonEncoder.convert(query);
  return encodeURI(jsonString, true);
}
