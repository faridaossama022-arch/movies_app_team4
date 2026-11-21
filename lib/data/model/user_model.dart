class UserModel {
  static const String collectionName = "users";

  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;

  UserModel({this.id, this.name, this.email, this.phone, this.avatar});

  UserModel.fromFireStore(Map<String, dynamic>? data) {
    id = data?["id"];
    name = data?["name"];
    email = data?["email"];
    phone = data?["phone"];
    avatar = data?["avatar"];
  }

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "avatar": avatar,
    };
  }
}