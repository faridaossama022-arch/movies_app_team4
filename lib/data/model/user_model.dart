class UserModel {
  static const String collectionName = "users";

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  UserModel.fromFireStore(Map<String, dynamic> data)
      : this(
    id: data["id"],
    name: data["name"],
    email: data["email"],
    phone: data["phone"],
    avatar: data["avatar"],
  );

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