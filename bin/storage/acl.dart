import '../common/index.dart';

abstract class AclOptions {
  late String pathPrefix;

  late RequestBodyCallback request;
}

typedef GetAclResponse = List<dynamic>; // [AccessControlObject | AccessControlObject[], Metadata]

typedef GetAclCallback = void Function(
  Exception? err,
  dynamic acl, // AccessControlObject | AccessControlObject[] | null
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

typedef RemoveAclResponse = List<Metadata>; // [Metadata];

typedef RemoveAclCallback = void Function(Exception? err, Metadata? apiResponse);

abstract class RemoveAclOptions {
  late String entity;
  int? generation;
  String? userProject;
}

abstract class AclQuery {
  late int generation;
  late String userProject;
  Map<String, dynamic> values = <String, dynamic>{};
}

abstract class AccessControlObject {
  late String entity;
  late String role;
  late String projectTeam;
}

// todo - finish class
class AclRoleAccessorMethods {
  AclRoleAccessorMethods({
    Map<dynamic, dynamic>? owners,
    Map<dynamic, dynamic>? readers,
    Map<dynamic, dynamic>? writers,
  }) {
    this.owners = owners ?? <dynamic, dynamic>{};
    this.readers = owners ?? <dynamic, dynamic>{};
    this.writers = owners ?? <dynamic, dynamic>{};

    _roles.forEach(_assignAccessMethods);
  }

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

  Map<dynamic, dynamic> owners = <dynamic, dynamic>{};

  Map<dynamic, dynamic> readers = <dynamic, dynamic>{};

  Map<dynamic, dynamic> writers = <dynamic, dynamic>{};

  void _assignAccessMethods(String role) {
    const List<String> accessMethods = AclRoleAccessorMethods._accessMethods;
    const List<String> entities = AclRoleAccessorMethods._entities;
    String roleGroup = role.toLowerCase() + 's';

    roleGroup = entities.reduce((String acc, final String entity) {
      final bool isPrefix = entity.endsWith('-');

      for (final String accessMethod in accessMethods) {
        String method = accessMethod + entity[0].toUpperCase() + entity.substring(1);

        if (isPrefix) {
          method = method.replaceAll('-', '');
        }
      }

      // todo - finish method

      return acc;
    });
  }
}

// todo - finish class
class Acl extends AclRoleAccessorMethods {
  Acl(AclOptions options) {
    // todo - call super
    pathPrefix = options.pathPrefix;
    request_ = options.request;
  }

  late String pathPrefix;

  // ignore: non_constant_identifier_names
  late RequestBodyCallback request_;

  // todo - finish method
  Future<AddAclResponse?> add(AddAclOptions options, AddAclCallback callback) async {
    AclQuery? query;

    if (options.generation != null) {
      query?.values['generation'] = options.generation;
    }

    if (options.userProject != null) {
      query?.values['userProject'] = options.userProject;
    }

    // todo - request

    AddAclResponse? addAclResponse;
    return addAclResponse;
  }
}
