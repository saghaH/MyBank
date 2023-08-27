class AuthenticatedUser {
  final String accessToken;
  final String type;
  final int id;
  final String username;
  final String email;
  final List<String> roles;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String dateOfBirth;
  final String cinNumber;
  //final String nationality;
  final String address;
  //final String countryOfResidence;
  //final String jobField;
  final String job;

  AuthenticatedUser({
    required this.accessToken,
    required this.type,
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.cinNumber,
    //required this.nationality,
    required this.address,
    //required this.countryOfResidence,
    //required this.jobField,
    required this.job,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      accessToken: json['accessToken'],
      type: json['tokenType'],
      id: json['user']['id'],
      username: json['user']['username'],
      email: json['user']['email'],
      roles: List<String>.from(json['user']['roles']),
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      mobileNumber: json['user']['mobileNumber'],
      dateOfBirth: json['user']['dateOfBirth'],
      cinNumber: json['user']['cinNumber'],
      //nationality: json['user']['nationality'],
      address: json['user']['address'],
      //countryOfResidence: json['user']['countryOfResidence'],
      //jobField: json['user']['jobField'],
      job: json['user']['job'],
    );
  }
}
