import '../common/index.dart';
import '../util/util.dart' as util;

class AclOptions {
  AclOptions(this.pathPrefix);

  String pathPrefix;
  // util.RequestCallback request;
}

typedef GetAclResponse = List<dynamic>; // [AccessControlObject | AccessControlObject[], Metadata]

typedef GetAclCallback = void Function(
  Exception? err,
  dynamic acl, // AccessControlObject | AccessControlObject[] | null
  Metadata? apiResponse,
);

class GetAclOptions {
  GetAclOptions(this.entity, [this.generation, this.userProject]);

  String entity;
  int? generation;
  String? userProject;
}

class UpdateAclOptions {
  UpdateAclOptions({required this.entity, required this.role, this.generation, this.userProject});

  String entity;
  String role;
  int? generation;
  String? userProject;
}

typedef UpdateAclResponse = List<dynamic>; // [AccessControlObject, Metadata]

typedef UpdateAclCallback = void Function(Exception? err, AccessControlObject? acl, Metadata? apiResponse);

abstract class AddAclOptions {
  AddAclOptions({required this.entity, required this.role, this.generation, this.userProject});

  String entity;
  String role;
  int? generation;
  String? userProject;
}

typedef AddAclResponse = List<dynamic>; // [AccessControlObject, Metadata]

typedef AddAclCallback = void Function(Exception? err, AccessControlObject? acl, Metadata? apiResponse);

typedef RemoveAclResponse = List<Metadata>; // [Metadata];

typedef RemoveAclCallback = void Function(Exception? err, Metadata? apiResponse);

abstract class RemoveAclOptions {
  RemoveAclOptions(this.entity, [this.generation, this.userProject]);

  String entity;
  int? generation;
  String? userProject;
}

class AclQuery {
  AclQuery(this.generation, this.userProject) : values = <String, dynamic>{};

  int generation;
  String userProject;
  Map<String, dynamic> values;
}

class AccessControlObject {
  AccessControlObject({required this.entity, required this.role, required this.projectTeam});

  String entity;
  String role;
  String projectTeam;
}

// todo - finish class
class AclRoleAccessorMethods {
  AclRoleAccessorMethods({
    Map<dynamic, dynamic>? owners,
    Map<dynamic, dynamic>? readers,
    Map<dynamic, dynamic>? writers,
  })  : owners = <dynamic, dynamic>{},
        readers = <dynamic, dynamic>{},
        writers = <dynamic, dynamic>{} {
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

  Map<dynamic, dynamic> owners;

  Map<dynamic, dynamic> readers;

  Map<dynamic, dynamic> writers;

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
    // request_ = options.request;
  }

  late String pathPrefix;

  // ignore: non_constant_identifier_names
  late util.RequestCallback request_;

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
