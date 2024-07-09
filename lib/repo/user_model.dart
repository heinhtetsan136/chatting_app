class ContactUser {
  final String uid;
  final String? displayName, photoURL, phoneNumber;
  final String email;

  ContactUser(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.photoURL,
      required this.phoneNumber});
  factory ContactUser.fromJson(dynamic data) {
    return ContactUser(
        uid: data["uid"],
        displayName: data["displayName"],
        email: data["email"],
        photoURL: data["photoURL"],
        phoneNumber: data["phoneNumber"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "displayName": displayName,
      "email": email,
      "photoURL": photoURL,
      "phoneNumber": phoneNumber
    };
  }
}
