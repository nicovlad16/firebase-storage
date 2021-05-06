import '../common/index.dart';

class GetPolicyOptions {
  GetPolicyOptions([this.userProject, this.requestedPolicyVersion]);

  String? userProject;
  int? requestedPolicyVersion;
}

typedef GetPolicyResponse = List<dynamic>; // [Policy, Metadata];

typedef GetPolicyCallback = void Function(Exception? err, Policy? acl, Metadata? apiResponse);

class SetPolicyOptions {
  SetPolicyOptions([this.userProject]);

  String? userProject;
}

typedef SetPolicyResponse = List<dynamic>; // [Policy, Metadata];

typedef SetPolicyCallback = void Function(Exception? err, Policy? acl, Map<dynamic, dynamic>? apiResponse);

class Policy {
  Policy(this.bindings, [this.version, this.etag]);

  List<PolicyBinding> bindings;
  int? version;
  String? etag;
}

class PolicyBinding {
  PolicyBinding(this.role, this.members, [this.condition]);

  String role;
  List<String> members;
  Expr? condition;
}

class Expr {
  Expr({this.title, this.description, required this.expression});

  String? title;
  String? description;
  String expression;
}

typedef TestIamPermissionsResponse = List<dynamic>; // [Map<String, bool>, Metadata];

typedef TestIamPermissionsCallback = void Function(Exception? err, Map<String, bool>? acl, Metadata? apiResponse);

class TestIamPermissionsOptions {
  TestIamPermissionsOptions([this.userProject]);

  String? userProject;
}

class GetPolicyRequest {
  GetPolicyRequest([this.userProject, this.optionsRequestedPolicyVersion]);

  String? userProject;
  int? optionsRequestedPolicyVersion;
}

// todo - finish class
class Iam {
  // String _resourceId_;

  // Iam(Bucket bucket){this._resourceId_=  'buckets/' + bucket.getId();};
}
