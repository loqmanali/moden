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
    final userJson = json['user'] as Map<String, dynamic>? ?? const {};
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
  final String? role;
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
      role: json['role']?.toString(),
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
      'role': role,
      '__v': version,
      'refreshToken': refreshToken,
    };
  }
}
