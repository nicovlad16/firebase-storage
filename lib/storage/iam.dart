import '../common/index.dart';
import 'bucket.dart';

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
  Iam(this.bucket) {
    // _request_ = ;
    _resourceId_ = 'buckets/' + bucket.getId();
  }

  final Bucket bucket;
  // final util.RequestCallback _request_;
  late String _resourceId_;

  /// @typedef {object} GetPolicyOptions Requested options for IAM#getPolicy().
  /// @property {number} [requestedPolicyVersion] The version of IAM policies to
  ///     request. If a policy with a condition is requested without setting
  ///     this, the server will return an error. This must be set to a value
  ///     of 3 to retrieve IAM policies containing conditions. This is to
  ///     prevent client code that isn't aware of IAM conditions from
  ///     interpreting and modifying policies incorrectly. The service might
  ///     return a policy with version lower than the one that was requested,
  ///     based on the feature syntax in the policy fetched.
  ///     @see [IAM Policy versions]{@link https://cloud.google.com/iam/docs/policies#versions}
  /// @property {string} [userProject] The ID of the project which will be
  ///     billed for the request.

/**/

  /// @typedef {array} GetPolicyResponse
  /// @property {Policy} 0 The policy.
  /// @property {object} 1 The full API response.
  ///

/**/

  /// @typedef {object} Policy
  /// @property {PolicyBinding[]} policy.bindings Bindings associate members with roles.
  /// @property {string} [policy.etag] Etags are used to perform a read-modify-write.
  /// @property {number} [policy.version] The syntax schema version of the Policy.
  ///      To set an IAM policy with conditional binding, this field must be set to
  ///      3 or greater.
  ///     @see [IAM Policy versions]{@link https://cloud.google.com/iam/docs/policies#versions}

/**/

  /// @typedef {object} PolicyBinding
  /// @property {string} role Role that is assigned to members.
  /// @property {string[]} members Specifies the identities requesting access for the bucket.
  /// @property {Expr} [condition] The condition that is associated with this binding.

/**/

  /// @typedef {object} Expr
  /// @property {string} [title] An optional title for the expression, i.e. a
  ///     short string describing its purpose. This can be used e.g. in UIs
  ///     which allow to enter the expression.
  /// @property {string} [description] An optional description of the
  ///     expression. This is a longer text which describes the expression,
  ///     e.g. when hovered over it in a UI.
  /// @property {string} expression Textual representation of an expression in
  ///     Common Expression Language syntax. The application context of the
  ///     containing message determines which well-known feature set of CEL
  ///     is supported.The condition that is associated with this binding.
  ///
  /// @see [Condition] https://cloud.google.com/storage/docs/access-control/iam#conditions

/**/

  /// Get the IAM policy.
  ///
  /// @param {GetPolicyOptions} [options] Request options.
  /// @param {GetPolicyCallback} [callback] Callback function.
  /// @returns {Promise<GetPolicyResponse>}
  ///
  /// @see [Buckets: setIamPolicy API Documentation]{@link https://cloud.google.com/storage/docs/json_api/v1/buckets/getIamPolicy}
  ///
  /// @example
  /// const {Storage} = require('@google-cloud/storage');
  /// const storage = new Storage();
  /// const bucket = storage.bucket('my-bucket');
  ///
  /// bucket.iam.getPolicy(
  ///     {requestedPolicyVersion: 3},
  ///     function(err, policy, apiResponse) {
  ///
  ///     },
  /// );
  ///
  /// //-
  /// // If the callback is omitted, we'll return a Promise.
  /// //-
  /// bucket.iam.getPolicy({requestedPolicyVersion: 3})
  ///   .then(function(data) {
  ///     const policy = data[0];
  ///     const apiResponse = data[1];
  ///   });
  ///
  /// @example <caption>include:samples/iam.js</caption>
  /// region_tag:storage_view_bucket_iam_members
  /// Example of retrieving a bucket's IAM policy:

  Future<GetPolicyResponse> getPolicy(GetPolicyOptions? options, GetPolicyCallback? callback) async {
    final GetPolicyRequest qs = GetPolicyRequest();
    if (options != null) {
      if (options.userProject != null) {
        qs.userProject = options.userProject;
      }
      if (options.requestedPolicyVersion != null) {
        qs.optionsRequestedPolicyVersion = options.requestedPolicyVersion;
      }
      // todo -  bucket.request();
    }

    return <dynamic>[];
  }
}
