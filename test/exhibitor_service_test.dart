import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:tiexpo/services/exhibitor_service.dart";

void main() {
  test("loads API exhibitor records from a nested response envelope", () async {
    final client = MockClient((request) async {
      expect(request.url.path, "/api/v1/exhibitors");
      return http.Response(
        jsonEncode({
          "data": {
            "items": [
              {
                "id": "api-company-1",
                "company_name": "API Textile Group",
                "category": "Materials",
                "booth_number": "A23",
                "hall_name": "Hall A",
                "description": "An API-provided company profile.",
                "products": [
                  {"name": "Recycled yarn"},
                  {"title": "Smart fabric"},
                ],
                "news": [
                  {
                    "title": "New collection",
                    "content": "API-backed company news.",
                    "published_at": "2026-10-01",
                  },
                ],
                "video_url": "https://example.com/company-video",
                "brochure_url": "https://example.com/company-brochure.pdf",
                "website": "https://example.com",
              },
            ],
          },
        }),
        200,
      );
    });

    final result = await ExhibitorService.load(client: client);
    client.close();

    expect(result.isDemo, isFalse);
    expect(result.exhibitors, hasLength(1));
    expect(result.exhibitors.single.name, "API Textile Group");
    expect(result.exhibitors.single.booth, "A23");
    expect(result.exhibitors.single.products, [
      "Recycled yarn",
      "Smart fabric",
    ]);
    expect(result.exhibitors.single.news.single.title, "New collection");
    expect(
      result.exhibitors.single.videoUrl,
      "https://example.com/company-video",
    );
    expect(
      result.exhibitors.single.brochureUrl,
      "https://example.com/company-brochure.pdf",
    );
    expect(result.exhibitors.single.website, "https://example.com");
  });

  test("uses clearly marked demo data when the API is unavailable", () async {
    final client = MockClient((_) async => http.Response("Not found", 404));

    final result = await ExhibitorService.load(client: client);
    client.close();

    expect(result.isDemo, isTrue);
    expect(result.message, contains("404"));
    expect(result.exhibitors, isNotEmpty);
    expect(result.exhibitors.every((exhibitor) => exhibitor.isDemo), isTrue);
  });
}
