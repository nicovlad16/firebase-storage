abstract class AclOptions {
  late String pathPrefix;
// todo - import from google cloud
// void request(DecorateRequestOptions request, BodyResponseCallback callback)
}

// todo - type - GetAclResponse

//todo - interface callback - GetAclResponse

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

// todo - type - UpdateAclResponse

// todo - interface callback - UpdateAclResponse

abstract class AddAclOptions {
  late String entity;
  late String role;
  int? generation;
  String? userProject;
}

// todo - type - AddAclResponse

// todo - interface callback - AddAclResponse

//todo - type - RemoveAclResponse

//todo - interface callback - RemoveAclCallback

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

  AclRoleAccessorMethods(this.owners, this.readers, this.writers);

  // todo - bind methods

  void _assignAccessMethods(String role) {
    var accessMethods = AclRoleAccessorMethods._accessMethods;
    var entities = AclRoleAccessorMethods._entities;
    var roleGroup = role.toLowerCase() + 's';

    // todo - finish method
  }
}
