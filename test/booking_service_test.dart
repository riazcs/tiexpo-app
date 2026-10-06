import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:tiexpo/services/booking_service.dart";

void main() {
  test("posts the authenticated meeting booking payload", () async {
    final client = MockClient((request) async {
      expect(request.method, "POST");
      expect(request.url.path, "/api/v1/bookings");
      expect(request.headers["authorization"], "Bearer test-token");
      expect(jsonDecode(request.body), {
        "user_id": "42",
        "company_id": "company-1",
        "time_slot": "Day 1 9.00AM- 9.30AM",
        "query": "Discuss recycled yarn",
      });
      return http.Response('{"success":true}', 201);
    });

    await BookingService.create(
      token: "test-token",
      userId: "42",
      companyId: "company-1",
      timeSlot: "Day 1 9.00AM- 9.30AM",
      query: "Discuss recycled yarn",
      client: client,
    );
    client.close();
  });
}
