class CustomUser {
  final String uid;
  final String fName;
  final String lName;
  final String photoUrl;

  CustomUser({this.uid, this.fName, this.lName, this.photoUrl});

  CustomUser.fromMap(Map map)
      : this.uid = map['uid'],
        this.fName = map['fName'],
        this.lName = map['lName'],
        this.photoUrl = map['photoUrl'];
}
