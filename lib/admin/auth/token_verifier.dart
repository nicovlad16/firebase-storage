// File created by
// Lung Razvan <long1eu>
// on 15/06/2020

part of auth;

// // URL containing the public keys for the Google certs (whose private keys are used to sign Firebase
// // Auth ID tokens)
// const String CLIENT_CERT_URL =
//     'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com';
//
// // URL containing the public keys for Firebase session cookies. This will be updated to a different URL soon.
// const String SESSION_COOKIE_CERT_URL = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/publicKeys';
//
// /// User facing token information related to the Firebase ID token.
// const FirebaseTokenInfo ID_TOKEN_INFO = FirebaseTokenInfo(
//   url: 'https://firebase.google.com/docs/auth/admin/verify-id-tokens',
//   verifyApiName: 'verifyIdToken()',
//   jwtName: 'Firebase ID token',
//   shortName: 'ID token',
//   expiredErrorCode: AuthClientErrorCode.ID_TOKEN_EXPIRED,
// );
//
// /// User facing token information related to the Firebase session cookie.
// const FirebaseTokenInfo SESSION_COOKIE_INFO = FirebaseTokenInfo(
//   url: 'https://firebase.google.com/docs/auth/admin/manage-cookies',
//   verifyApiName: 'verifySessionCookie()',
//   jwtName: 'Firebase session cookie',
//   shortName: 'session cookie',
//   expiredErrorCode: AuthClientErrorCode.SESSION_COOKIE_EXPIRED,
// );
//
// /// Token related user facing information.
// class FirebaseTokenInfo {
//   const FirebaseTokenInfo({
//     required this.url,
//     required this.verifyApiName,
//     required this.jwtName,
//     required this.shortName,
//     required this.expiredErrorCode,
//   });
//
//   /// Documentation URL.
//   final String url;
//
//   /// verify API name.
//   final String verifyApiName;
//
//   /// The JWT full name.
//   final String jwtName;
//
//   /// The JWT short name.
//   final String shortName;
//
//   /// JWT Expiration error code.
//   final ErrorInfo expiredErrorCode;
// }
//
// /// Class for verifying general purpose Firebase JWTs. This verifies ID tokens and session cookies.
// class FirebaseTokenVerifier {
//   /*private*/ Map<String, String> publicKeys;
//
//   /*private*/
//   int publicKeysExpireAt;
//
//   /*private*/
//   String shortNameArticle;
//
//   /*private*/
//   FirebaseTokenInfo tokenInfo;
//
//   String algorithm;
//   String issuer;
//   String clientCertUrl;
//
//   /*FirebaseApp*/
//   dynamic app;
//
//
//   FirebaseTokenVerifier(String clientCertUrl, String algorithm,
//       String issuer, FirebaseTokenInfo tokenInfo,
//       FirebaseApp app) {
//     if (Uri.tryParse(clientCertUrl) == null) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The provided public client certificate URL is an invalid URL.',
//       );
//     } else if (algorithm.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The provided JWT algorithm is an empty string.',
//       );
//     } else if (issuer.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The provided JWT issuer is an invalid URL.',
//       );
//     } else if (tokenInfo == null) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The provided JWT information is not an object or null.',
//       );
//     } else if (Uri.tryParse(tokenInfo.url) == null) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The provided JWT verification documentation URL is invalid.',
//       );
//     } else if (tokenInfo.verifyApiName.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The JWT verify API name must be a non-empty string.',
//       );
//     } else if (tokenInfo.jwtName.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The JWT public full name must be a non-empty string.',
//       );
//     } else if (tokenInfo.shortName.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The JWT public short name must be a non-empty string.',
//       );
//     } else if (tokenInfo.expiredErrorCode != null) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'The JWT expiration error code must be a non-null ErrorInfo object.',
//       );
//     }
//
//     shortNameArticle = <String>['a', 'e', 'i', 'o', 'u'].contains(tokenInfo.expiredErrorCode) ? 'an' : 'a';
//     // For backward compatibility, the project ID is validated in the verification call.
//   }
//
//   /**
//    * Verifies the format and signature of a Firebase Auth JWT token.
//    *
//    * @param {string} jwtToken The Firebase Auth JWT token to verify.
//    * @return {Promise<DecodedIdToken>} A promise fulfilled with the decoded claims of the Firebase Auth ID
//    *                           token.
//    */
//   Future<DecodedIdToken> verifyJWT(String jwtToken) async {
//     final String projectId = (await util.findProjectId(this.app)) as String
//     return verifyJWTWithProjectId(jwtToken, projectId);
//   }
//
//   Future<DecodedIdToken> verifyJWTWithProjectId(String jwtToken, [String projectId]) async {
//     if (projectId != null) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_CREDENTIAL,
//         'Must initialize app with a cert credential or set your Firebase project ID as the '
//             'GOOGLE_CLOUD_PROJECT environment variable to call ${tokenInfo.verifyApiName}.',
//       );
//     }
//
//     final Map<String, dynamic> fullDecodedToken = jwt.decode(jwtToken, {complete: true,});
//
//     final Map<String, dynamic> header = fullDecodedToken['header'];
//     final Map<String, dynamic> payload = fullDecodedToken['payload'];
//
//     final String projectIdMatchMessage = ' Make sure the ${tokenInfo.shortName} comes from the same '
//         'Firebase project as the service account used to authenticate this SDK.';
//     final String verifyJwtTokenDocsMessage = ' See ${tokenInfo.url} '
//         'for details on how to retrieve ${shortNameArticle} ${tokenInfo.shortName}.';
//
//     String errorMessage;
//     if (fullDecodedToken == null) {
//       errorMessage = 'Decoding ${tokenInfo.jwtName} failed. Make sure you passed the entire string JWT '
//           'which represents $shortNameArticle ${tokenInfo.shortName}. $verifyJwtTokenDocsMessage';
//     } else if (!header.containsKey('kid')) {
//       final bool isCustomToken = payload['aud'] == _kFirebaseAudience;
//       final bool isLegacyCustomToken = header['alg'] == 'HS256' //
//           && '${payload['v']}' == '0' &&
//           payload.containsKey('d') &&
//           (payload['d'] as Map<String, dynamic>).containsKey('uid');
//
//       if (isCustomToken) {
//         errorMessage = '${tokenInfo.verifyApiName} expects $shortNameArticle '
//             '${tokenInfo.shortName}, but was given a custom token.';
//       } else if (isLegacyCustomToken) {
//         errorMessage = '${tokenInfo.verifyApiName} expects $shortNameArticle '
//             '${tokenInfo.shortName}, but was given a legacy custom token.';
//       } else {
//         errorMessage = 'Firebase ID token has no "kid" claim.';
//       }
//
//       errorMessage += verifyJwtTokenDocsMessage;
//     } else if (header['alg'] != algorithm) {
//       errorMessage = '${tokenInfo.jwtName} has incorrect algorithm. Expected "$algorithm" but got '
//           '"${header['alg']}".$verifyJwtTokenDocsMessage';
//     } else if (payload['aud'] != projectId) {
//       errorMessage = '${tokenInfo.jwtName} has incorrect "aud" (audience) claim. Expected "$projectId'
//           '" but got "${payload['aud']}".$projectIdMatchMessage$verifyJwtTokenDocsMessage';
//     } else if (payload['iss'] != issuer + projectId) {
//       errorMessage = '${tokenInfo.jwtName} has incorrect "iss" (issuer) claim. Expected '
//           '"$issuer"$projectId" but got "${payload['iss']}".$projectIdMatchMessage$verifyJwtTokenDocsMessage';
//     } else if (!payload.containsKey('sub') && payload['sub'] is! String) {
//       errorMessage = '${tokenInfo.jwtName} has no "sub" (subject) claim.$verifyJwtTokenDocsMessage';
//     } else if ((payload['sub'] as String).isEmpty) {
//       errorMessage = '${tokenInfo.jwtName} has an empty string "sub" (subject) claim.$verifyJwtTokenDocsMessage';
//     } else if ((payload['sub'] as String).length > 128) {
//       errorMessage =
//       '${tokenInfo.jwtName} has "sub" (subject) claim longer than 128 characters.$verifyJwtTokenDocsMessage';
//     }
//     if (errorMessage != null) {
//       return Future<DecodedIdToken>.error(FirebaseError.auth(AuthClientErrorCode.INVALID_ARGUMENT, errorMessage));
//     }
//
//     final Map<String, String> publicKeys = await fetchPublicKeys();
//
//     if (publicKeys[header['kid']] == null) {
//       return Future<DecodedIdToken>.error(
//         FirebaseError.auth(
//           AuthClientErrorCode.INVALID_ARGUMENT,
//           '${tokenInfo.jwtName} has "kid" claim which does not correspond to a known public key. '
//               'Most likely the ${tokenInfo.shortName} is expired, so get a fresh token from your '
//               'client app and try again.',
//         ),
//       );
//     } else {
//       return verifyJwtSignatureWithKey(jwtToken, publicKeys[header['kid']]);
//     }
//   }
//
//   /**
//    * Verifies the JWT signature using the provided public key.
//    * @param {string} jwtToken The JWT token to verify.
//    * @param {string} publicKey The public key certificate.
//    * @return {Future<DecodedIdToken>} A promise that resolves with the decoded JWT claims on successful
//    *     verification.
//    */
//   Future<DecodedIdToken> verifyJwtSignatureWithKey(String jwtToken, String publicKey) {
//     final String verifyJwtTokenDocsMessage = ' See ${tokenInfo.url} '
//         'for details on how to retrieve $shortNameArticle ${tokenInfo.shortName}.';
//     final Completer<DecodedIdToken> completer = Completer<DecodedIdToken>();
//
//     jwt.verify(jwtToken, publicKey, {
//       'algorithms': [this.algorithm],
//     }, (jwt.VerifyErrors error, Map<String, dynamic> decodedToken) {
//       if (error != null) {
//         if (error.name == 'TokenExpiredError') {
//           final String errorMessage = '${tokenInfo.jwtName} has expired. Get a fresh ${tokenInfo.shortName}'
//               ' from your client app and try again (auth/${tokenInfo.expiredErrorCode
//               .code}).$verifyJwtTokenDocsMessage';
//           return completer.completeError(FirebaseError.auth(tokenInfo.expiredErrorCode, errorMessage));
//         } else if (error.name == 'JsonWebTokenError') {
//           final String errorMessage = '${tokenInfo.jwtName} has invalid signature.$verifyJwtTokenDocsMessage';
//           return completer.completeError(FirebaseError.auth(AuthClientErrorCode.INVALID_ARGUMENT, errorMessage));
//         }
//         return completer.completeError(FirebaseError.auth(AuthClientErrorCode.INVALID_ARGUMENT, error.message));
//       } else {
//         final DecodedIdToken decodedIdToken = (decodedToken as DecodedIdToken);
//         decodedIdToken.uid = decodedIdToken.sub;
//         completer.complete(decodedIdToken);
//       }
//     });
//
//     return completer.future;
//   }
//
//   /// Fetches the public keys for the Google certs.
//   ///
//   /// Returns the public keys for the Google certs.
//   Future<Map<String, String>> fetchPublicKeys() async {
//     final bool publicKeysExist = publicKeys != null;
//     final bool publicKeysExpiredExists = publicKeysExpireAt != null;
//     final bool publicKeysStillValid = publicKeysExpiredExists && DateTime
//         .now()
//         .millisecondsSinceEpoch < publicKeysExpireAt;
//     if (publicKeysExist && publicKeysStillValid) {
//       return Future<Map<String, String>>.value(publicKeys);
//     }
//
//     Response response;
//     Map<String, String> resp;
//     response = await get(clientCertUrl, headers: <String, String>{'user-agent': app.options.httpAgent});
//
//     if (response.statusCode >= 400) {
//       String errorMessage = 'Error fetching public keys for Google certs: ';
//       try {
//         resp = jsonDecode(response.body) as Map<String, String>;
//         errorMessage = '$errorMessage${resp['error']}';
//         if (resp['error_description'] != null) {
//           errorMessage = '$errorMessage (${resp['error_description']})';
//         }
//       } catch (e) {
//         errorMessage = '$errorMessage${response.body}';
//       }
//       throw FirebaseError.auth(AuthClientErrorCode.INTERNAL_ERROR, errorMessage);
//     }
//
//
//     if (response.headers.containsKey('cache-control')) {
//       final String cacheControlHeader = response.headers['cache-control'];
//
//       final List<String> parts = cacheControlHeader.split(',');
//       for (final String part in parts) {
//         final List<String> subParts = part.trim().split('=');
//         if (subParts[0] == 'max-age') {
//           final int maxAge = int.parse(subParts[1]);
//           publicKeysExpireAt = DateTime
//               .now()
//               .millisecondsSinceEpoch + (maxAge * 1000);
//         }
//       }
//     }
//     publicKeys = resp;
//     return resp;
//   }
// }
// /*
// /**
//  * Creates a new FirebaseTokenVerifier to verify Firebase ID tokens.
//  *
//  * @param {FirebaseApp} app Firebase app instance.
//  * @return {FirebaseTokenVerifier}
//  */
// export function createIdTokenVerifier(app: FirebaseApp): FirebaseTokenVerifier {
//   return new FirebaseTokenVerifier(
//     CLIENT_CERT_URL,
//     _kAlgorithmRS256,
//     'https://securetoken.google.com/',
//     ID_TOKEN_INFO,
//     app,
//   );
// }
//
// /**
//  * Creates a new FirebaseTokenVerifier to verify Firebase session cookies.
//  *
//  * @param {FirebaseApp} app Firebase app instance.
//  * @return {FirebaseTokenVerifier}
//  */
// export function createSessionCookieVerifier(app: FirebaseApp): FirebaseTokenVerifier {
//   return new FirebaseTokenVerifier(
//     SESSION_COOKIE_CERT_URL,
//     _kAlgorithmRS256,
//     'https://session.firebase.google.com/',
//     SESSION_COOKIE_INFO,
//     app,
//   );
// }
//
// * */
