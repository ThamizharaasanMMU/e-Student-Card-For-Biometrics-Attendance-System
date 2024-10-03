class MMUsers {
  final String uid;

  MMUsers({required this.uid});
}


class MMUserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String password;
  final String userID;
  final String userType;

  MMUserData({required this.uid, required this.firstName,
    required this.lastName, required this.password,
    required this.userID, required this.userType});
}