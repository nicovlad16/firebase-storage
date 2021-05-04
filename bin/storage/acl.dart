import '../common/index.dart';

abstract class AclOptions {
  late String pathPrefix;
// todo - import from google cloud
// void request(DecorateRequestOptions request, BodyResponseCallback callback)
}

typedef GetAclResponse = List<dynamic /* AccessControlObject | AccessControlObject[], Metadata */ >;

typedef GetAclCallback = void Function(
  Exception? err,
  dynamic acl /* AccessControlObject | AccessControlObject[] | null */,
  Metadata? apiResponse,
);

abstract class GetAclOptions {
  late String entity;
  int? generation;
  String? userProject;
}

abstract class UpdateAclOptions {
  late String entity;
  late String role;
  int? generation;
  String? userProject;
}

typedef UpdateAclResponse = List<dynamic>; // [AccessControlObject, Metadata]

typedef UpdateAclCallback = void Function(Exception? err, AccessControlObject? acl, Metadata? apiResponse);

abstract class AddAclOptions {
  late String entity;
  late String role;
  int? generation;
  String? userProject;
}

typedef AddAclResponse = List<dynamic>; // [AccessControlObject, Metadata]

typedef AddAclCallback = void Function(Exception? err, AccessControlObject? acl, Metadata? apiResponse);

typedef RemoveAclResponse = List<Metadata>;

typedef RemoveAclCallback = void Function(Exception? err, Metadata? apiResponse);

abstract class RemoveAclOptions {
  late String entity;
  int? generation;
  String? userProject;
}

abstract class AclQuery {
  late int generation;
  late String userProject;
}

abstract class AccessControlObject {
  late String entity;
  late String role;
  late String projectTeam;
}

// todo - finish class
class AclRoleAccessorMethods {
  static const List<String> _accessMethods = <String>['add', 'delete'];

  static const List<String> _entities = <String>[
    // Special entity groups that do not require further specification.
    'allAuthenticatedUsers',
    'allUsers',

    // Entity groups that require specification, e.g. `user-email@example.com`.
    'domain-',
    'group-',
    'project-',
    'user-',
  ];

  static const List<String> _roles = <String>['OWNER', 'READER', 'WRITER'];

  Map<dynamic, dynamic> owners = {};

  Map<dynamic, dynamic> readers = {};

  Map<dynamic, dynamic> writers = {};

  AclRoleAccessorMethods({this.owners = const {}, this.readers = const {}, this.writers = const {}});

  // todo - bind methods

  void _assignAccessMethods(String role) {
    var accessMethods = AclRoleAccessorMethods._accessMethods;
    var entities = AclRoleAccessorMethods._entities;
    var roleGroup = role.toLowerCase() + 's';

    // todo - finish method
  }
}

// todo - finish class
class Acl extends AclRoleAccessorMethods {
  Acl() : super();
}
