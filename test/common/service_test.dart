import 'package:firebase_storage/auth/google_auth.dart';
import 'package:firebase_storage/common/index.dart';
import 'package:test/test.dart';

void main() {
  group('Service', () {
    const String BASE_URL = 'base-url';
    const bool PROJECT_ID_REQUIRED = false;
    const String API_ENDPOINT = 'common.endpoint.local';
    final PackageJson packageJson = PackageJson('@google-cloud/service', '0.2.0');
    late ServiceConfig config;
    const String EMAIL = 'email';
    const String PROJECT_ID = 'project-id';
    const String TOKEN = 'token';
    final GoogleAuth authClient = GoogleAuth();
    late ServiceOptions options;
    late Service service;

    setUp(() {
      config = ServiceConfig(
        scopes: <String>[],
        baseUrl: BASE_URL,
        projectIdRequired: PROJECT_ID_REQUIRED,
        apiEndpoint: API_ENDPOINT,
        packageJson: packageJson,
      );
      options = ServiceOptions(
        authClient: authClient,
        email: EMAIL,
        projectId: PROJECT_ID,
        token: TOKEN,
      );
      service = Service(config, options);
    });
    group('instantiation', () {
      test('should localize the authClient', () {
        // todo - test
      });

      test('should localize the provided authClient', () {
        service = Service(config, options);
        expect(service.authClient, options.authClient);
      });

      test('should allow passing a custom GoogleAuth client', () {
        config.authClient = authClient;
        service = Service(config);
        expect(service.authClient, authClient);
      });

      test('should localize the baseUrl', () {
        expect(service.baseUrl, config.baseUrl);
      });

      test('should localize the apiEndpoint', () {
        expect(service.apiEndpoint, config.apiEndpoint);
      });

      test('should default the timeout to null', () {
        expect(service.timeout, null);
      });

      test('should localize the timeout', () {
        const int timeout = 10000;
        options.timeout = timeout;
        service = Service(config, options);
        expect(service.timeout, timeout);
      });

      test('should default globalInterceptors to an empty array', () {
        expect(service.globalInterceptors, <Interceptor>[]);
      });

      test('should preserve the original global interceptors', () {
        final List<Interceptor> globalInterceptors = <Interceptor>[];
        options.interceptors_ = globalInterceptors;
        service = Service(config, options);
        expect(service.globalInterceptors, globalInterceptors);
      });

      test('should default interceptors to an empty array', () {
        expect(service.interceptors, <Interceptor>[]);
      });

      test('should localize package.json', () {
        expect(service.packageJson, config.packageJson);
      });

      test('should localize the projectId', () {
        expect(service.projectId, options.projectId);
      });

      test('should default projectId with placeholder', () {
        service = Service(config);
        expect(service.projectId, '{{projectId}}');
      });

      test('should localize the projectIdRequired', () {
        expect(service.projectIdRequired, config.projectIdRequired);
      });

      test('should default projectIdRequired to true', () {
        config.projectIdRequired = null;
        service = Service(config, options);
        expect(service.projectIdRequired, true);
      });
    });
  });
}
