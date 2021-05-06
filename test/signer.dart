import 'package:firebase_storage/storage/index.dart';
import 'package:firebase_storage/storage/util.dart';
import 'package:test/test.dart';

void main() {
  const String BUCKET_NAME = 'bucket-name';
  const String FILE_NAME = 'file-name.png';
  const String CLIENT_EMAIL = 'client-email';

  group('URLSigner', () {
    final AuthClient authClient = AuthClient(
      sign: (_) async => 'signature',
      getCredentials: () async => GetCredentialsResponse(client_email: CLIENT_EMAIL),
    );
    final BucketI bucket = BucketI(BUCKET_NAME);
    final FileI file = FileI(FILE_NAME);

    DateTime NOW = DateTime.parse('2019-03-18T00:00:00Z');

    group('URLSigner constructor', () {
      late URLSigner signer;

      setUp(() {
        signer = URLSigner(authClient, bucket, file);
      });

      test('should localize authClient', () {
        expect(signer.authClient, authClient);
      });

      test('should localize bucket', () {
        expect(signer.bucket, bucket);
      });

      test('should localize file', () {
        expect(signer.file, file);
      });
    });

    group('getSignedUrl', () {
      late URLSigner signer;
      SignerGetSignedUrlConfig CONFIG;

      setUp(() {
        signer = URLSigner(authClient, bucket, file);
        CONFIG = SignerGetSignedUrlConfig(
          method: 'GET',
          expires: NOW,
        );

        group('version', () {
          test('should default to v2 if version is not given', () async {
            // todo - find a way to use mock
            //    const v2;
            // // eslint-disable-next-line @typescript-eslint/no-explicit-any
            //     .stub<any, any>(signer, 'getSignedUrlV2')
            //     .resolves({});

            await signer.getSignedUrl(CONFIG);
            // assert(v2.calledOnce);
          });
        });
      });
    });

    group('getCanonicalHeaders', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);

      test('should accept multi-valued header as an array', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'foo': <String>['bar', 'pub'],
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'foo:bar,pub\n');
      });

      test('should lowercase and then sort header names', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'B': 'foo',
          'a': 'bar',
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'a:bar\nb:foo\n');
      });

      test('should trim leading and trailing space', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'foo': '  bar   ',
          'my': '\t  header  ',
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'foo:bar\nmy:header\n');
      });

      test('should convert sequential spaces into single space', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'foo': 'a\t\t\tbar   pub',
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'foo:a bar pub\n');
      });
    });

    group('getCanonicalRequest', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);
      const String method = 'DELETE';
      const String path = 'path';
      const String query = 'query';
      const String headers = 'headers';
      const String signedHeaders = 'signedHeaders';

      test('should return canonical request string with unsigned-payload', () {
        final String canonical = signer.getCanonicalRequest(
          method: method,
          path: path,
          query: query,
          headers: headers,
          signedHeaders: signedHeaders,
        );

        final String expected = <String>[method, path, query, headers, signedHeaders, 'UNSIGNED-PAYLOAD'].join('\n');
        expect(canonical, expected);
      });

      test('should include contentSha256 value if not undefined', () {
        const String SHA = '76af7efae0d034d1e3335ed1b90f24b6cadf2bf1';
        final String canonical = signer.getCanonicalRequest(
          method: method,
          path: path,
          query: query,
          headers: headers,
          signedHeaders: signedHeaders,
          contentSha256: SHA,
        );

        final String expected = <String>[method, path, query, headers, signedHeaders, SHA].join('\n');
        expect(canonical, expected);
      });
    });

    group('getCanonicalQueryParams', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);

      test('should encode key', () {
        const String key = 'AZ!*()*%/f';
        final Query query = Query();
        query.values[key] = 'value';
        final String canonical = signer.getCanonicalQueryParams(query);

        final String expected = '${encodeURI(key, true)}=value';
        expect(canonical, expected);
      });

      test('should encode value', () {
        const String key = 'key';
        const String value = 'AZ!*()*%/f';
        final Query query = Query();
        query.values[key] = value;
        final String canonical = signer.getCanonicalQueryParams(query);

        final String expected = '$key=${encodeURI(value, true)}';
        expect(canonical, expected);
      });

      test('should sort by key', () {
        final Query query = Query();
        query.values = <String, dynamic>{
          'B': 'bar',
          'A': 'foo',
        };
        final String canonical = signer.getCanonicalQueryParams(query);

        const String expected = 'A=foo&B=bar';
        expect(canonical, expected);
      });
    });

    group('getResourcePath', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);

      test('should not include bucket with cname', () {
        final String path = signer.getResourcePath(true, bucket.name, file.name);
        expect(path, '/${file.name}');
      });

      test('should include file name', () {
        final String path = signer.getResourcePath(false, bucket.name, file.name);
        expect(path, '/${bucket.name}/${file.name}');
      });

      test('should return path with no file name', () {
        final String path = signer.getResourcePath(false, bucket.name, null);
        expect(path, '/${bucket.name}');
      });
    });

    group('parseExpires', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);

      test('throws invalid date', () {
        expect(
          () => signer.parseExpires('2019-31-'),
          throwsA(
            isA<String>()
                .having((String exception) => exception, 'message', 'The expiration date provided was invalid.'),
          ),
        );
      });

      test('throws if expiration is in the past', () {
        expect(
          () => signer.parseExpires(NOW.subtract(const Duration(seconds: 1)), current: NOW),
          throwsA(
            isA<String>()
                .having((String exception) => exception, 'message', 'An expiration date cannot be in the past.'),
          ),
        );
      });

      test('returns expiration date in seconds', () {
        final DateTime now = DateTime.now().add(const Duration(seconds: 1));
        final int expires = signer.parseExpires(now);
        expect(expires, (now.millisecondsSinceEpoch / 1000).floor());
      });
    });
  });
}
