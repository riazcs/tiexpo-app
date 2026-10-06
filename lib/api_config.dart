class ApiConfig {
  static const String baseUrl = "https://api.textileinnovationexpo.com/api/v1";
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
}
