// File created by
// Lung Razvan <long1eu>
// on 11/06/2020

library auth;

import 'dart:async';

part 'credentials.dart';
part 'token_generator.dart';
part 'token_verifier.dart';

const String _kAlgorithmRS256 = 'RS256';

// Audience to use for Firebase Auth Custom tokens
const String _kFirebaseAudience =
    'https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit';
