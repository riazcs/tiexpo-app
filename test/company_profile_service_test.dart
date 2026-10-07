import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:tiexpo/services/company_profile_service.dart";

void main() {
  test("loads public company profile fields from the slug endpoint", () async {
    final client = MockClient((request) async {
      expect(request.url.path, "/api/get-company-details/tech-cell-bd-ltd");
      return http.Response(
        jsonEncode({
          "company": {
            "id": 98,
            "name": "Tech Cell BD Ltd.",
            "image": {
              "original_image_path": "/storage/uploads/company/cover.jpg",
            },
            "company_details": {
              "slug": "tech-cell-bd-ltd",
              "category": {"name": "Machinery"},
              "logo": "/storage/uploads/company/logo.jpg",
              "about": "<p>Company <strong>about</strong> text.</p>",
              "address": "Dhaka, Bangladesh",
              "established_year": 2017,
              "number_of_employees": "11-50",
              "target_market": "Asia",
              "main_products": "Machinery",
              "website": "https://example.com",
            },
            "products": [
              {
                "name": "Smart textile machine",
                "description": "A production solution.",
                "image": {
                  "original_image_path": "/storage/uploads/product/item.jpg",
                },
              },
            ],
            "videos": [
              {"url": "https://youtube.com/watch?v=abc123"},
            ],
          },
        }),
        200,
      );
    });

    final exhibitor = await CompanyProfileService.load(
      slug: "tech-cell-bd-ltd",
      client: client,
    );
    client.close();

    expect(exhibitor.name, "Tech Cell BD Ltd.");
    expect(exhibitor.slug, "tech-cell-bd-ltd");
    expect(exhibitor.category, "Machinery");
    expect(exhibitor.logoUrl, "/storage/uploads/company/logo.jpg");
    expect(exhibitor.coverUrl, "/storage/uploads/company/cover.jpg");
    expect(exhibitor.blurb, contains("<strong>about</strong>"));
    expect(exhibitor.address, "Dhaka, Bangladesh");
    expect(exhibitor.establishedYear, "2017");
    expect(exhibitor.employeeCount, "11-50");
    expect(exhibitor.targetMarket, "Asia");
    expect(exhibitor.products, ["Smart textile machine"]);
    expect(
      exhibitor.productDetails.single.imageUrl,
      "/storage/uploads/product/item.jpg",
    );
    expect(exhibitor.videoUrls, ["https://youtube.com/watch?v=abc123"]);
  });
}
