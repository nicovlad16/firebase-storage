import '../common/index.dart';

abstract class GetPolicyOptions {
  String? userProject;
  int? requestedPolicyVersion;
}

typedef GetPolicyResponse = List<dynamic>; // [Policy, Metadata];

typedef GetPolicyCallback = void Function(Exception? err, Policy? acl, Metadata? apiResponse);

abstract class SetPolicyOptions {
  String? userProject;
}

typedef SetPolicyResponse = List<dynamic>; // [Policy, Metadata];

typedef SetPolicyCallback = void Function(Exception? err, Policy? acl, Map<dynamic, dynamic>? apiResponse);

abstract class Policy {
  late List<PolicyBinding> bindings;
  int? version;
  String? etag;
}

abstract class PolicyBinding {
  late String role;
  late List<String> members;
  Expr? condition;
}

abstract class Expr {
  String? title;
  String? description;
  late String expression;
}

typedef TestIamPermissionsResponse = List<dynamic>; // [Map<String, bool>, Metadata];

typedef TestIamPermissionsCallback = void Function(Exception? err, Map<String, bool>? acl, Metadata? apiResponse);

abstract class TestIamPermissionsOptions {
  String? userProject;
}

abstract class GetPolicyRequest {
  String? userProject;
  int? optionsRequestedPolicyVersion;
}

// todo - finish class
class Iam {
  // String _resourceId_;

  // Iam(Bucket bucket){this._resourceId_=  'buckets/' + bucket.getId();};
}
