abstract final class AppConstants {
  static const String emailRegex = r"^[\w\.-]+@[\w-]+\.[\w\.]+$";
  static const String moviesApiBaseUrl = "https://yts.bz/api/v2/";

  /// دومينات احتياطية: لو الأول مفتحش التطبيق بيجرّب اللي بعده تلقائيًا.
  static const List<String> moviesApiMirrors = [
    "https://yts.bz/api/v2/",
    "https://yts.mx/api/v2/",
    "https://yts.am/api/v2/",
    "https://yts.ag/api/v2/",
  ];
}
