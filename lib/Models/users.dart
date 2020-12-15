class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String role;
  final String fName;
  final String lName;
  final String userName;
  final String phoneNo;
  final String emailAddress;
  final String photoUrl;

  UserData(
      {this.uid,
      this.role,
      this.fName,
      this.lName,
      this.userName,
      this.phoneNo,
      this.emailAddress,
      this.photoUrl});
}
