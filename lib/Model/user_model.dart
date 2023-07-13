class UserModel{
  final String name;
  final String email;
  final String bio;
  final String profile_pic;
  final String  phno;
  final String createdAt;
  final String uid;
  UserModel({
    required this.name,
    required this.email,
  required this.bio,
  required this.profile_pic,
  required this.phno,
  required this.createdAt,
  required this.uid,
});
//getting data from server
  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(name: map['name']??'',
        email: map['email']??'',
        bio: map['bio']??'',
        profile_pic: map['profile_pic']??'',
        phno: map['phno']??'',
        createdAt: map['createdAt']??'',
        uid:map['uid']??'');
  }

  //sending data to server
Map<String,dynamic> toMap(){
    return {
      'name':name,
      'email': email,
  'bio': bio,
  'profile_pic': profile_pic,
  'phno': phno,
  'createdAt': createdAt,
  'uid':uid,
  };
}
}