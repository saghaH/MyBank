enum Role {
  USER,
  ADMIN,
}

extension RoleExtension on Role {
  String get value {
    switch (this) {
      case Role.USER:
        return 'User';
      case Role.ADMIN:
        return 'Admin';
      default:
        throw Exception("Unknown role");
    }
  }
}
