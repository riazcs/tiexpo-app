import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:tiexpo/services/exhibitor_service.dart";

void main() {
  test("loads one featured-company page at a time", () async {
    final client = MockClient((request) async {
      expect(request.url.host, "api.textiletoday.org");
      expect(request.url.path, "/api/get-featured-companies");
      final page = request.url.queryParameters["page"];
      if (page == "1") {
        return http.Response(
          jsonEncode({
            "status": "success",
            "companies": [
              {
                "id": 16,
                "name": "Apna Organics",
                "member_type": 30,
                "company_details": {
                  "company_id": 16,
                  "slug": "apna-organics",
                  "logo": "/storage/uploads/company/apna-organics/logo.jpg",
                  "category": {"id": 8, "name": "Dyes & Chemicals"},
                },
              },
            ],
            "pagination": {
              "current_page": 1,
              "per_page": 1,
              "total": 2,
              "last_page": 2,
              "has_more_pages": true,
            },
          }),
          200,
        );
      }
      expect(page, "2");
      return http.Response(
        jsonEncode({
          "status": "success",
          "companies": [
            {
              "id": 43,
              "name": "InspirOn Engineering Pvt. Ltd.",
              "member_type": 20,
              "company_details": {
                "company_id": 43,
                "slug": "inspiron-engineering-pvt-ltd",
                "logo":
                    "/storage/uploads/company/inspiron-engineering/logo.jpg",
                "category": {"id": 9, "name": "Machinery"},
              },
            },
          ],
          "pagination": {
            "current_page": 2,
            "per_page": 1,
            "total": 2,
            "last_page": 2,
            "has_more_pages": false,
          },
        }),
        200,
      );
    });

    final firstPage = await ExhibitorService.load(client: client);
    client.close();

    expect(firstPage.isDemo, isFalse);
    expect(firstPage.exhibitors, hasLength(1));
    expect(firstPage.hasMorePages, isTrue);
    expect(firstPage.exhibitors.single.name, "Apna Organics");
    expect(firstPage.exhibitors.single.id, "16");
    expect(firstPage.exhibitors.single.category, "Dyes & Chemicals");
    expect(
      firstPage.exhibitors.single.logoUrl,
      "/storage/uploads/company/apna-organics/logo.jpg",
    );

    final secondPageClient = MockClient((request) async {
      expect(request.url.queryParameters["page"], "2");
      return http.Response(
        jsonEncode({
          "status": "success",
          "companies": [
            {
              "id": 43,
              "name": "InspirOn Engineering Pvt. Ltd.",
              "member_type": 20,
              "company_details": {
                "company_id": 43,
                "slug": "inspiron-engineering-pvt-ltd",
                "logo":
                    "/storage/uploads/company/inspiron-engineering/logo.jpg",
                "category": {"id": 9, "name": "Machinery"},
              },
            },
          ],
          "pagination": {
            "current_page": 2,
            "per_page": 1,
            "total": 2,
            "last_page": 2,
            "has_more_pages": false,
          },
        }),
        200,
      );
    });
    final secondPage = await ExhibitorService.load(
      page: 2,
      client: secondPageClient,
    );
    secondPageClient.close();

    expect(secondPage.isDemo, isFalse);
    expect(secondPage.exhibitors.single.name, "InspirOn Engineering Pvt. Ltd.");
    expect(secondPage.exhibitors.single.category, "Machinery");
    expect(secondPage.hasMorePages, isFalse);
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

  test(
    "keeps later-page failures retryable without replacing loaded data",
    () async {
      final client = MockClient(
        (_) async => http.Response("Server error", 500),
      );

      final result = await ExhibitorService.load(page: 2, client: client);
      client.close();

      expect(result.isDemo, isFalse);
      expect(result.exhibitors, isEmpty);
      expect(result.hasMorePages, isTrue);
      expect(result.message, contains("500"));
    },
  );
}
