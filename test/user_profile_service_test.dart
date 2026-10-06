import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:tiexpo/services/user_profile_service.dart";

void main() {
  test("fetches the authenticated profile and unwraps data.user", () async {
    final client = MockClient((request) async {
      expect(request.method, "GET");
      expect(request.url.path, "/api/v1/user/profile");
      expect(request.headers["authorization"], "Bearer profile-token");
      return http.Response(
        jsonEncode({
          "success": true,
          "data": {
            "user": {"id": 494, "name": "Riazul Islam"},
          },
        }),
        200,
      );
    });

    final user = await UserProfileService.load(
      token: "profile-token",
      client: client,
    );
    client.close();

    expect(user, {"id": 494, "name": "Riazul Islam"});
  });
}
