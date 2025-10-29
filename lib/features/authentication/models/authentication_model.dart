class AuthenticationModel {
  final String message;
  final AuthenticatedUser user;
  final String token;

  const AuthenticationModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) {
    // New API shape: user fields at root with role object and token
    final Map<String, dynamic> userJson = json;

    return AuthenticationModel(
      message: json['message'] as String? ?? '',
      user: AuthenticatedUser.fromJson(userJson),
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'token': token,
    };
  }
}

class AuthenticatedUser {
  final String id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String email;
  final String? nationalId;
  final String? mobileNumber;
  final List<dynamic> applications;
  final UserRole? role;
  final int? version;
  final String? refreshToken;

  const AuthenticatedUser({
    required this.id,
    required this.email,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.nationalId,
    this.mobileNumber,
    this.applications = const [],
    this.role,
    this.version,
    this.refreshToken,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    final applicationsJson = json['applications'];
    // New API: role is an object with permissions
    final Map<String, dynamic>? roleJson =
        json['role'] is Map<String, dynamic> ? json['role'] as Map<String, dynamic> : null;
    return AuthenticatedUser(
      id: json['_id']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      middleName: json['middle_name']?.toString(),
      lastName: json['last_name']?.toString(),
      gender: json['gender']?.toString(),
      email: json['email']?.toString() ?? '',
      nationalId: json['national_id']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      applications: applicationsJson is List<dynamic>
          ? List<dynamic>.from(applicationsJson)
          : const [],
      role: roleJson != null ? UserRole.fromJson(roleJson) : null,
      version: json['__v'] is int
          ? json['__v'] as int
          : int.tryParse('${json['__v']}'),
      refreshToken: json['refreshToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'email': email,
      'national_id': nationalId,
      'mobile_number': mobileNumber,
      'applications': applications,
      'role': role?.toJson(),
      '__v': version,
      'refreshToken': refreshToken,
    };
  }
}

class UserRole {
  final String? id;
  final String name;
  final List<String> permissions;
  final int? version;

  const UserRole({
    this.id,
    this.name = '',
    this.permissions = const [],
    this.version,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    final perms = json['permissions'];
    return UserRole(
      id: json['_id']?.toString(),
      name: json['name']?.toString() ?? '',
      permissions: perms is List
          ? perms.map((e) => e.toString()).toList()
          : const [],
      version: json['__v'] is int
          ? json['__v'] as int
          : int.tryParse('${json['__v']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'permissions': permissions,
      '__v': version,
    };
  }
}
