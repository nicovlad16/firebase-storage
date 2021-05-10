import 'package:firebase_storage/admin/auth/index.dart';

class ServiceAccountCredential extends Credential {
  late String projectId;

  @override
  Future<GoogleOAuthAccessToken> getAccessToken() {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }
}
