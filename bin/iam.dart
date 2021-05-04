abstract class GetPolicyOptions {
  String? userProject;
  int? requestedPolicyVersion;
}

// todo - type - GetPolicyResponse
// todo - callback - GetPolicyCallback

abstract class SetPolicyOptions {
  String? userProject;
}

// todo - type - SetPolicyResponse
// todo - callback - SetPolicyCallback

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

// todo - type - TestIamPermissionsResponse
// todo - callback - TestIamPermissionsCallback

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
