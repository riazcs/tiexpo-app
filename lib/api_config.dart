class ApiConfig {
  static const String baseUrl = "https://api.textileinnovationexpo.com/api";
  static const int connectTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;

  static const Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "App-Version": "1.0.0",
    "Platform": "android",
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    "Authorization": "Bearer $token",
  };

  static const login = "/login";
  static const register = "/register";
  static const profile = "/user/profile";
  static const events = "/events";
  static const schedule = "/schedule";
  static const speakers = "/speakers";
  static const exhibitors = "/exhibitors";
  static const bookings = "/bookings";
  static const sessions = "/sessions";
  static const tickets = "/tickets";
  static const notifications = "/notifications";
  static const floorPlan = "/floor-plan";
  static const booths = "/booths";
  static const search = "/search";
  static const home = "/home";
  static const banners = "/banners";

  // Textile Today / featured companies
  static const String textileTodayBaseUrl = "https://api.textiletoday.org";
  static const String featuredCompanies =
      "$textileTodayBaseUrl/api/get-featured-companies";
  static const String featuredCompanyAssetsBaseUrl = textileTodayBaseUrl;

  /// Company detail by slug, e.g. tech-cell-bd-ltd
  static String companyDetails(String slug) =>
      "$textileTodayBaseUrl/api/get-company-details/$slug";

  static const String visitorRecaptchaSiteKey =
      "6LcOEiojAAAAAMwQuDe2fwdajwKbB4fGgNPM0irS";

  /// Turn relative storage path into full image URL
  /// Input:  /storage/uploads/company/tech-cell-bd-ltd/tech_cell_bd_ltd_17337175498344.jpg
  /// Output: https://api.textiletoday.org/storage/uploads/company/...
  static String? resolveAssetUrl(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    final trimmed = path.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (uri.hasScheme) return uri.toString(); // already absolute
    final normalized = trimmed.startsWith("/") ? trimmed : "/$trimmed";
    return "$featuredCompanyAssetsBaseUrl$normalized";
  }
}
