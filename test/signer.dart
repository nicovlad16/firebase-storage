import 'dart:convert';

import 'package:firebase_storage/storage/index.dart';
import 'package:firebase_storage/storage/util.dart';
import 'package:firebase_storage/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mocks/signer.dart';

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
      final URLSigner signer = URLSigner(authClient, bucket, file);
      final URLSignerFake signerFake = URLSignerFake(authClient, bucket, file);
      const String method = 'GET';
      late SignerGetSignedUrlConfig config;
      late GetSignedUrlConfigInternal configInternal;

      setUp(() {
        config = SignerGetSignedUrlConfig(
          method: method,
          expires: DateTime.now().add(const Duration(days: 2)),
        );

        configInternal = GetSignedUrlConfigInternal(
          expiration: parseExpires(config.expires),
          method: method,
          bucket: bucket.name,
          config: config,
        );
      });

      group('version', () {
        test('should use v2 if set', () async {
          config
            ..version = 'v2'
            ..contentMd5 = 'md5'
            ..contentType = 'application/json'
            ..extensionHeaders = <String, dynamic>{'key': 'value'};
          // todo - check this
          // var signedUrl = await signer.getSignedUrl(config);
          // expect(signedUrl.bucket, bucket.name);
          // expect(v2arg.method, config.method);
          // expect(v2arg.contentMd5, config.contentMd5);
          // expect(v2arg.contentType, config.contentType);
          // expect(v2arg.extensionHeaders, config.extensionHeaders);
        });
      });

      test('v2: should generate URL with given cname', () async {
        config.version = 'v2';
        config.cname = 'https://www.example.com';
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith('https://www.example.com/${file.name}'));
      });

      test('v4: should generate URL with given cname', () async {
        config.version = 'v4';
        config.cname = 'https://www.example.com';
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith('https://www.example.com/${file.name}'));
      });

      test('v2: should remove trailing slashes from cname', () async {
        config.version = 'v2';
        config.cname = 'https://www.example.com//';
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith('https://www.example.com/${file.name}'));
      });

      test('v4: should remove trailing slashes from cname', () async {
        config.version = 'v4';
        config.cname = 'https://www.example.com//';
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith('https://www.example.com/${file.name}'));
      });

      test('v2: should generate virtual hosted style URL', () async {
        config.version = 'v2';
        config.virtualHostedStyle = true;
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith('https://${bucket.name}.storage.googleapis.com/${file.name}'));
      });

      test('v4: should generate virtual hosted style URL', () async {
        config.version = 'v4';
        config.virtualHostedStyle = true;
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith('https://${bucket.name}.storage.googleapis.com/${file.name}'));
      });

      test('v2: should generate path styled URL', () async {
        config.version = 'v2';
        config.virtualHostedStyle = false;
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith(PATH_STYLED_HOST));
      });

      test('v4: should generate path styled URL', () async {
        config.version = 'v4';
        config.virtualHostedStyle = false;
        final String signedUrl = await signer.getSignedUrl(config);
        expect(signedUrl, startsWith(PATH_STYLED_HOST));
      });

      test('should generate URL with returned query params appended', () async {
        final Map<String, dynamic> values = <String, dynamic>{
          'X-Goog-Foo': 'value',
          'X-Goog-Bar': 'azAZ!*()*%',
        };
        final V2SignedUrlQuery query = V2SignedUrlQuery();
        query.values = values;
        when(signerFake.getSignedUrlV2(configInternal)).thenAnswer((_) async => query);
        // sandbox
        // // eslint-disable-next-line @typescript-eslint/no-explicit-any
        //     .stub<any, any>(signer, 'getSignedUrlV2')
        //     .resolves(query);

        // todo - finish test - find a way to mock things while using real class methods
        final String signedUrl = await signerFake.getSignedUrl(config);
        expect(signedUrl, stringContainsInOrder(<String>[qsStringify(values)]));
      });
    });

    group('getSignedUrlV2', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);
      late GetSignedUrlConfigInternal configInternal;
      const String method = 'GET';

      setUp(() {
        configInternal = GetSignedUrlConfigInternal(
            expiration: DateTime.now().add(const Duration(seconds: 2)).millisecondsSinceEpoch ~/ 1000,
            method: method,
            bucket: bucket.name,
            file: file.name);
      });

      test('should return v2 query', () async {
        final V2SignedUrlQuery query = await signer.getSignedUrlV2(configInternal);

        final Map<String, dynamic> expected = <String, dynamic>{
          'GoogleAccessId': CLIENT_EMAIL,
          'Expires': configInternal.expiration,
          'Signature': 'signature',
        };
        expect(query.values, expected);
      });
    });

    group('getSignedUrlV4', () {
      final URLSigner signer = URLSigner(authClient, bucket, file);
      late GetSignedUrlConfigInternal config;
      const String method = 'GET';

      setUp(() {
        config = GetSignedUrlConfigInternal(
          expiration: DateTime.now().add(const Duration(seconds: 2)).millisecondsSinceEpoch ~/ 1000,
          method: method,
          bucket: bucket.name,
        );
      });

      test('should fail for expirations beyond 7 days', () {
        config.expiration =
            DateTime.now().add(const Duration(seconds: 8 * 24 * 60 * 60)).millisecondsSinceEpoch ~/ 1000;
        const int SEVEN_DAYS = 7 * 24 * 60 * 60;

        expect(
            () => signer.getSignedUrlV4(config),
            throwsA(isA<String>().having(
              (String message) => message,
              'message',
              'Max allowed expiration is seven days ($SEVEN_DAYS seconds).',
            )));
      });

      test('should returns query params with signature', () async {
        config.queryParams = Query();
        config.queryParams!.values = <String, dynamic>{
          'foo': 'bar',
        };

        final V4SignedUrlQuery query = await signer.getSignedUrlV4(config);
        final String signatureInHex = base64.encode(utf8.encode('signature'));
        expect(query.values['X-Goog-Signature'], signatureInHex);
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
      test('throws invalid date', () {
        expect(
          () => parseExpires('2019-31-'),
          throwsA(
            isA<String>()
                .having((String exception) => exception, 'message', 'The expiration date provided was invalid.'),
          ),
        );
      });

      test('throws if expiration is in the past', () {
        final DateTime dateTime = DateTime.now();
        expect(
          () => parseExpires(dateTime.subtract(const Duration(seconds: 1)), current: dateTime),
          throwsA(
            isA<String>()
                .having((String exception) => exception, 'message', 'An expiration date cannot be in the past.'),
          ),
        );
      });

      test('returns expiration date in seconds', () {
        final DateTime now = DateTime.now().add(const Duration(seconds: 2));
        final int expires = parseExpires(now);
        expect(expires, (now.millisecondsSinceEpoch / 1000).floor());
      });
    });
  });
}
