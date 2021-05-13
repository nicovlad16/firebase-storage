import 'package:firebase_storage/auth/credentials.dart';

class GoogleAuthOptions {
  GoogleAuthOptions({this.keyFilename, this.keyFile, this.credentials, this.projectId, this.authClient});

  /// Path to a .json, .pem, or .p12 key file
  String? keyFilename;

  /// Path to a .json, .pem, or .p12 key file
  String? keyFile;

  /// Object containing client_email and private_key properties, or the
  /// external account client options.
  dynamic credentials; // CredentialBody | ExternalAccountClientOptions;

  // todo
  // /// Options object passed to the constructor of the client
  // clientOptions?: JWTOptions | OAuth2ClientOptions | UserRefreshClientOptions;
  //
  // /// Required scopes for the desired API request
  // scopes?: string | string[];

  /// Your project ID.
  String? projectId;

  GoogleAuth? authClient;
}

class GoogleAuth {
  // todo - class
  GoogleAuth([GoogleAuthOptions? options]) {
    options ??= GoogleAuthOptions();
  }

  Future<CredentialBody> getCredentials() async {
    // todo - method
    return CredentialBody();
  }
}
