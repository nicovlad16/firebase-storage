// File created by
// Lung Razvan <long1eu>
// on 11/06/2020

part of auth;

// const int ONE_HOUR_IN_SECONDS = 60 * 60;
//
// // List of blacklisted claims which cannot be provided when creating a custom token
// const List<String> _kBlacklistedClaims = <String>[
//   'acr',
//   'amr',
//   'at_hash',
//   'aud',
//   'auth_time',
//   'azp',
//   'cnf',
//   'c_hash',
//   'exp',
//   'iat',
//   'iss',
//   'jti',
//   'nbf',
//   'nonce',
// ];
//
// /// CryptoSigner interface represents an object that can be used to sign JWTs.
// abstract class CryptoSigner {
//   /// Cryptographically signs a buffer of data.
//   ///
//   /// [Uint8List] buffer The data to be signed.
//   /// Returns A promise that resolves with the raw bytes of a signature.
//   Future<Uint8List> sign(Uint8List buffer);
//
//   /// Returns the ID of the service account used to sign tokens.
//   ///
//   /// Returns A promise that resolves with a service account ID.
//   Future<String> getAccountId();
// }
//
// /// A [CryptoSigner] implementation that uses an explicitly specified service account private key to
// /// sign data. Performs all operations locally, and does not make any RPC calls.
// class ServiceAccountSigner implements CryptoSigner {
//   /// Creates a new CryptoSigner instance from the given service account credential.
//   ///
//   /// [credential] A service account credential.
//   ServiceAccountSigner(this._credential);
//
//   final ServiceAccountCredentials _credential;
//
//   @override
//   Future<Uint8List> sign(Uint8List buffer) async {
//     final RS256Signer signer = RS256Signer(_credential.privateRSAKey);
//     return Uint8List.fromList(signer.sign(buffer));
//   }
//
//   @override
//   Future<String> getAccountId() {
//     return Future<String>.value(_credential.email);
//   }
// }
//
// /// A CryptoSigner implementation that uses the remote IAM service to sign data. If initialized without
// /// a service account ID, attempts to discover a service account ID by consulting the local Metadata
// /// service. This will succeed in managed environments like Google Cloud Functions and App Engine.
// ///
// /// @see https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/signBlob
// /// @see https://cloud.google.com/compute/docs/storing-retrieving-metadata
// class IAMSigner implements CryptoSigner {
//   IAMSigner(AuthorizedHttpClient httpClient, [this._serviceAccountId])
//       : _serviceAccountsResourceApi = IamApi(httpClient).projects.serviceAccounts {
//     final String? serviceAccountId = _serviceAccountId;
//     if (serviceAccountId != null && serviceAccountId.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         'INTERNAL ASSERT: Service account ID must be undefined or a non-empty String.',
//       );
//     }
//   }
//
//   final ProjectsServiceAccountsResourceApi _serviceAccountsResourceApi;
//   final String? _serviceAccountId;
//
//   @override
//   Future<Uint8List> sign(Uint8List buffer) async {
//     try {
//       final String serviceAccount = await getAccountId();
//       final SignBlobRequest request = SignBlobRequest()..bytesToSignAsBytes = buffer;
//       final SignBlobResponse response =
//           await _serviceAccountsResourceApi.signBlob(request, 'projects/-/serviceAccounts/$serviceAccount');
//
//       return Uint8List.fromList(response.signatureAsBytes);
//     } on DetailedApiRequestError catch (e) {
//       final String errorCode = e.message;
//       const String description = 'Please refer to https://firebase.google.com/docs/auth/admin/create-custom-tokens '
//           'for more details on how to use and troubleshoot this feature.';
//       final String errorMsg = '${e.message}; $description';
//
//       throw FirebaseError.authFromServerCode(errorCode, errorMsg, e.jsonResponse);
//     } catch (e) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INTERNAL_ERROR,
//         'Error returned from server: $e. Additionally, an internal error occurred while attempting to extract the errorcode from the error.',
//       );
//     }
//   }
//
//   @override
//   Future<String> getAccountId() async {
//     if (_serviceAccountId.isNotEmpty) {
//       return Future<String>.value(_serviceAccountId);
//     }
//
//     Response response;
//     try {
//       response = await get(
//         'http://metadata/computeMetadata/v1/instance/service-accounts/default/email',
//         headers: <String, String>{
//           'Metadata-Flavor': 'Google',
//         },
//       );
//     } catch (e) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_CREDENTIAL,
//         'Failed to determine service account. Make sure to initialize '
//         'the SDK with a service account credential. Alternatively specify a service '
//         'account with iam.serviceAccounts.signBlob permission. Original error: $e',
//       );
//     }
//
//     if (response.body.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INTERNAL_ERROR,
//         'HTTP Response missing payload',
//       );
//     }
//
//     return response.body;
//   }
// }
//
// /* todo
// /**
//  * Create a new CryptoSigner instance for the given app. If the app has been initialized with a service
//  * account credential, creates a ServiceAccountSigner. Otherwise creates an IAMSigner.
//  *
//  * [FirebaseApp] app A FirebaseApp instance.
//  * Returns A CryptoSigner instance.
//  */
// export function cryptoSignerFromApp(FirebaseApp app): CryptoSigner {
//   const credential = app.options.credential;
//   if (credential instanceof ServiceAccountCredential) {
//     return new ServiceAccountSigner(credential);
//   }
//
//   return new IAMSigner(new AuthorizedHttpClient(app), app.options.serviceAccountId);
// }
// */
//
// /// Class for generating different types of Firebase Auth tokens (JWTs).
// class FirebaseTokenGenerator {
//   /// [tenantId] The tenant ID to use for the generated Firebase Auth Custom token.
//   /// If absent, then no tenant ID claim will be set in the resulting JWT.
//   FirebaseTokenGenerator(this._signer, [this._tenantId]) {
//     if (_signer == null) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_CREDENTIAL,
//         'INTERNAL ASSERT: Must provide a CryptoSigner to use FirebaseTokenGenerator.',
//       );
//     }
//     if (_tenantId != null && _tenantId.isEmpty) {
//       throw FirebaseError.auth(
//         AuthClientErrorCode.INVALID_ARGUMENT,
//         '`tenantId` argument must be a non-empty String.',
//       );
//     }
//   }
//
//   final CryptoSigner _signer;
//   final String _tenantId;
//
//   /// Creates a new Firebase Auth Custom token.
//   ///
//   /// [uid] The user ID to use for the generated Firebase Auth Custom token.
//   /// [developerClaims] Optional developer claims to include in the generated Firebase
//   /// Auth Custom token.
//   ///
//   /// Returns a Future resolved with a Firebase Auth Custom token signed with a service
//   /// account key and containing the provided payload.
//   Future<String> createCustomToken(String uid,
//       [Map<String, dynamic> developerClaims = const <String, dynamic>{}]) async {
//     String errorMessage;
//     if (uid.isEmpty) {
//       errorMessage = '`uid` argument must be a non-empty String uid.';
//     } else if (uid.length > 128) {
//       errorMessage = '`uid` argument must a uid with less than or equal to 128 characters.';
//     } else if (developerClaims == null) {
//       errorMessage = '`developerClaims` argument must be a valid, non-null object containing the developer claims.';
//     }
//
//     if (errorMessage != null) {
//       throw FirebaseError.auth(AuthClientErrorCode.INVALID_ARGUMENT, errorMessage);
//     }
//
//     final Map<String, dynamic> claims = <String, dynamic>{};
//     for (final String key in developerClaims.keys) {
//       if (_kBlacklistedClaims.contains(key)) {
//         throw FirebaseError.auth(
//           AuthClientErrorCode.INVALID_ARGUMENT,
//           'Developer claim "$key" is reserved and cannot be specified.',
//         );
//       }
//       claims[key] = developerClaims[key];
//     }
//
//     final String account = await _signer.getAccountId();
//     final Map<String, String> header = <String, String>{
//       'alg': _kAlgorithmRS256,
//       'typ': 'JWT',
//     };
//     final int iat = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     final Map<String, dynamic> body = <String, dynamic>{
//       'aud': _kFirebaseAudience,
//       'iat': 'iat',
//       'exp': iat + ONE_HOUR_IN_SECONDS,
//       'iss': account,
//       'sub': account,
//       'uid': 'uid',
//       if (_tenantId != null) 'tenant_id': _tenantId,
//       if (claims.isNotEmpty) 'claims': claims,
//     };
//
//     final String token = '${_encodeSegment(header)}.${_encodeSegment(body)}';
//     final Uint8List signature = await _signer.sign(Uint8List.fromList(utf8.encode(token)));
//     return '$token.${base64UrlEncode(signature).replaceAll('=', '')}';
//   }
//
//   String _encodeSegment(Map<String, dynamic> segment) {
//     return base64UrlEncode(utf8.encode(jsonEncode(segment))).replaceAll('=', '');
//   }
// }
