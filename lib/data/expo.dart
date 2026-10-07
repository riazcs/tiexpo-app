class ExpoInfo {
  static const name = "TIExpo";

  static const fullName = "Textile Innovation Expo";

  static const edition = "2026";

  static const city = "Dhaka";

  static const country = "Bangladesh";

  static const venue = "International Convention City Bashundhara (ICCB)";

  static const venueShort = "ICCB";

  static const address =
      "International Convention City Bashundhara (ICCB), Dhaka, Bangladesh";

  static const datesLabel = "12–14 November 2026";

  static const openingHours = "10:00 AM – 6:00 PM Daily";

  static const entry = "Free for Registered Trade Visitors";

  static const registrationRequired = true;

  static const expectedVisitors = "15,000+";

  static const expectedExhibitors = "300+";

  static const technicalSessions = "20+";

  static const website = "https://textileinnovationexpo.com/";

  static const days = <(int, String)>[
    (1, "Thu 12 Nov"),
    (2, "Fri 13 Nov"),
    (3, "Sat 14 Nov"),
  ];
}

// ============================================================
// SPEAKER
// ============================================================

class Speaker {
  const Speaker({
    required this.id,
    required this.name,
    required this.title,
    required this.org,
    required this.bio,
    required this.initials,
    required this.tone,
  });

  final String id;
  final String name;
  final String title;
  final String org;
  final String bio;
  final String initials;
  final String tone;
}

// Official speaker information is not currently published
// on the public website.
//
// Keep this empty instead of using fictional speaker data.
const speakers = <Speaker>[];

// ============================================================
// EXHIBITOR
// ============================================================

class Exhibitor {
  const Exhibitor({
    required this.id,
    required this.name,
    required this.category,
    required this.booth,
    required this.hall,
    required this.blurb,
    required this.tags,
    this.slug,
    this.products = const [],
    this.productDetails = const [],
    this.news = const [],
    this.logoUrl,
    this.coverUrl,
    this.videoUrl,
    this.videoUrls = const [],
    this.brochureUrl,
    this.website,
    this.address,
    this.establishedYear,
    this.employeeCount,
    this.targetMarket,
    this.mainProducts,
    this.isDemo = false,
  });

  factory Exhibitor.fromJson(Map<String, dynamic> json) {
    final rawCompany = json["company"];
    final company = rawCompany is Map
        ? Map<String, dynamic>.from(rawCompany)
        : json;
    final rawDetails = company["company_details"];
    final details = rawDetails is Map
        ? Map<String, dynamic>.from(rawDetails)
        : const <String, dynamic>{};
    final rawCategory = details["category"];
    final categoryDetails = rawCategory is Map
        ? Map<String, dynamic>.from(rawCategory)
        : const <String, dynamic>{};
    final name = _jsonString(company, const [
      "name",
      "company_name",
      "companyName",
      "company",
    ]);
    if (name.isEmpty) {
      throw const FormatException(
        "Exhibitor record is missing a company name.",
      );
    }

    final category = _jsonString(company, const [
      "category",
      "industry",
      "sector",
    ]).ifEmpty(_jsonString(categoryDetails, const ["name"]));
    final tags = _jsonStringList(company["tags"]);
    final products = _jsonStringList(
      company["products"] ??
          company["solutions"] ??
          company["product_lines"] ??
          details["main_products"],
    );
    final productDetails = _exhibitorProducts(company["products"]);
    final rawImage = company["image"];
    final image = rawImage is Map
        ? Map<String, dynamic>.from(rawImage)
        : const <String, dynamic>{};
    final videos = _jsonStringList(company["videos"]);
    return Exhibitor(
      id: _jsonString(company, const ["id", "uuid", "slug"])
          .ifEmpty(
            _jsonString(details, const ["company_id", "id", "slug"]),
          )
          .ifEmpty(name),
      slug: _jsonString(details, const ["slug"])
          .ifEmpty(_jsonString(company, const ["slug"]))
          .nullIfEmpty,
      name: name,
      category: category.ifEmpty("Exhibitor"),
      booth: _jsonString(company, const [
        "booth",
        "booth_number",
        "boothNo",
      ]).ifEmpty("TBA"),
      hall: _jsonString(company, const [
        "hall",
        "hall_name",
        "venue",
      ]).ifEmpty("To be announced"),
      blurb: _jsonString(company, const [
        "about",
        "description",
        "blurb",
        "bio",
        "company_profile",
      ]).ifEmpty(
        _jsonString(details, const ["about"]).ifEmpty(
          "Company information has not been published yet.",
        ),
      ),
      tags: tags.isEmpty && category.isNotEmpty ? [category] : tags,
      products: products,
      productDetails: productDetails,
      news: _companyNewsList(
        company["news"] ?? company["updates"] ?? company["announcements"],
      ),
      logoUrl: _jsonString(company, const [
        "logo_url",
        "logoUrl",
        "logo",
      ])
          .ifEmpty(_jsonString(details, const ["logo_url", "logoUrl"]))
          .ifEmpty(_jsonString(details, const ["logo"]))
          .ifEmpty(
            _jsonString(image, const ["original_image_path", "path", "url"]),
          )
          .nullIfEmpty,
      coverUrl: _jsonString(company, const ["cover_url", "coverUrl", "banner"])
          .ifEmpty(_jsonString(details, const ["banner"]))
          .ifEmpty(
            _jsonString(image, const ["original_image_path", "path", "url"]),
          )
          .nullIfEmpty,
      videoUrl: _jsonString(company, const ["video_url", "videoUrl"])
          .ifEmpty(_jsonString(details, const ["video_link"]))
          .ifEmpty(videos.isEmpty ? "" : videos.first)
          .nullIfEmpty,
      videoUrls: videos,
      brochureUrl: _jsonString(company, const [
        "brochure_url",
        "brochureUrl",
        "catalogue_url",
        "catalogueUrl",
        "catalog_url",
        "catalogUrl",
      ]).nullIfEmpty,
      website: _jsonString(company, const [
        "website",
        "website_url",
        "websiteUrl",
      ]).ifEmpty(_jsonString(details, const ["website"])).nullIfEmpty,
      address: _jsonString(details, const ["address"]).nullIfEmpty,
      establishedYear: _jsonString(details, const ["established_year"])
          .nullIfEmpty,
      employeeCount: _jsonString(details, const ["number_of_employees"])
          .nullIfEmpty,
      targetMarket: _jsonString(details, const ["target_market"]).nullIfEmpty,
      mainProducts: _jsonString(details, const ["main_products"]).nullIfEmpty,
    );
  }

  Exhibitor withProfile(Exhibitor profile) => Exhibitor(
    id: id,
    slug: profile.slug ?? slug,
    name: profile.name.isNotEmpty ? profile.name : name,
    category: profile.category != "Exhibitor" ? profile.category : category,
    booth: profile.booth != "TBA" ? profile.booth : booth,
    hall: profile.hall != "To be announced" ? profile.hall : hall,
    blurb:
        profile.blurb != "Company information has not been published yet."
        ? profile.blurb
        : blurb,
    tags: profile.tags.isNotEmpty ? profile.tags : tags,
    products: profile.products.isNotEmpty ? profile.products : products,
    productDetails: profile.productDetails.isNotEmpty
        ? profile.productDetails
        : productDetails,
    news: profile.news.isNotEmpty ? profile.news : news,
    logoUrl: profile.logoUrl ?? logoUrl,
    coverUrl: profile.coverUrl ?? coverUrl,
    videoUrl: profile.videoUrl ?? videoUrl,
    videoUrls: profile.videoUrls.isNotEmpty ? profile.videoUrls : videoUrls,
    brochureUrl: profile.brochureUrl ?? brochureUrl,
    website: profile.website ?? website,
    address: profile.address ?? address,
    establishedYear: profile.establishedYear ?? establishedYear,
    employeeCount: profile.employeeCount ?? employeeCount,
    targetMarket: profile.targetMarket ?? targetMarket,
    mainProducts: profile.mainProducts ?? mainProducts,
    isDemo: isDemo,
  );

  final String id;
  final String? slug;
  final String name;
  final String category;
  final String booth;
  final String hall;
  final String blurb;
  final List<String> tags;
  final List<String> products;
  final List<ExhibitorProduct> productDetails;
  final List<CompanyNews> news;
  final String? logoUrl;
  final String? coverUrl;
  final String? videoUrl;
  final List<String> videoUrls;
  final String? brochureUrl;
  final String? website;
  final String? address;
  final String? establishedYear;
  final String? employeeCount;
  final String? targetMarket;
  final String? mainProducts;
  final bool isDemo;
}

class ExhibitorProduct {
  const ExhibitorProduct({
    required this.name,
    this.description,
    this.imageUrl,
  });

  final String name;
  final String? description;
  final String? imageUrl;
}

List<ExhibitorProduct> _exhibitorProducts(Object? value) {
  if (value is! Iterable) return const [];
  return value
      .whereType<Map>()
      .map((record) {
        final product = Map<String, dynamic>.from(record);
        final rawImage = product["image"];
        final image = rawImage is Map
            ? Map<String, dynamic>.from(rawImage)
            : const <String, dynamic>{};
        return ExhibitorProduct(
          name: _jsonString(product, const ["name", "title"]),
          description: _jsonString(product, const ["description"]).nullIfEmpty,
          imageUrl: _jsonString(product, const [
            "image_url",
            "imageUrl",
            "image",
          ])
              .ifEmpty(
                _jsonString(image, const [
                  "original_image_path",
                  "path",
                  "url",
                ]),
              )
              .nullIfEmpty,
        );
      })
      .where((product) => product.name.isNotEmpty)
      .toList();
}

class CompanyNews {
  const CompanyNews({required this.title, this.body = "", this.date = ""});

  final String title;
  final String body;
  final String date;
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;

  String? get nullIfEmpty => isEmpty ? null : this;
}

String _jsonString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value is num) return value.toString();
  }
  return "";
}

List<String> _jsonStringList(Object? value) {
  if (value is String) {
    return value
        .split(",")
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }
  if (value is Iterable) {
    return value
        .map((entry) {
          if (entry is String) return entry.trim();
          if (entry is Map<String, dynamic>) {
            return _jsonString(entry, const [
              "name",
              "title",
              "label",
              "product",
              "url",
            ]);
          }
          return "";
        })
        .where((entry) => entry.isNotEmpty)
        .toList();
  }
  return const [];
}

List<CompanyNews> _companyNewsList(Object? value) {
  if (value is! Iterable) return const [];
  return value
      .map((entry) {
        if (entry is String) return CompanyNews(title: entry);
        if (entry is Map<String, dynamic>) {
          final title = _jsonString(entry, const ["title", "headline", "name"]);
          if (title.isEmpty) return null;
          return CompanyNews(
            title: title,
            body: _jsonString(entry, const ["body", "description", "content"]),
            date: _jsonString(entry, const [
              "date",
              "published_at",
              "publishedAt",
            ]),
          );
        }
        return null;
      })
      .whereType<CompanyNews>()
      .toList();
}

// The official exhibitor directory currently says:
// "Exhibitors Coming Soon."
//
// Therefore no unverified company names are included here.
const exhibitors = <Exhibitor>[];

const demoExhibitors = <Exhibitor>[
  Exhibitor(
    id: "demo-loom-works",
    name: "Demo Loom Works",
    category: "Textile machinery",
    booth: "A12",
    hall: "Hall A",
    blurb:
        "Sample company profile for previewing the TIExpo exhibitor directory and meeting flow.",
    tags: ["jacquard", "automation"],
    products: ["Demo Jacquard Loom", "Sample Weave Control System"],
    news: [
      CompanyNews(
        title: "Sample product announcement",
        body:
            "This example item demonstrates where company updates will appear.",
        date: "Demo content",
      ),
    ],
    isDemo: true,
  ),
  Exhibitor(
    id: "demo-fiber-lab",
    name: "Demo Fiber Lab",
    category: "Textile materials",
    booth: "B08",
    hall: "Hall B",
    blurb:
        "Sample materials exhibitor with preview data for fibers, yarns, and technical textiles.",
    tags: ["smart fibers", "technical textiles"],
    products: ["Demo Smart Fiber", "Sample Technical Textile Range"],
    isDemo: true,
  ),
];

// ============================================================
// EXHIBITION CATEGORY
// ============================================================

class ExpoCategory {
  const ExpoCategory({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.tags,
  });

  final String id;
  final String name;
  final String title;
  final String description;
  final List<String> tags;
}

const expoCategories = <ExpoCategory>[
  ExpoCategory(
    id: "dyeing-printing",
    name: "Dyeing & Printing",
    title: "Dyeing & Printing Innovation Expo 2026",
    description:
        "Innovations in dyeing, printing, coloration, processing, "
        "sustainable chemistry and textile finishing.",
    tags: ["Dyeing", "Printing", "Color", "Chemicals", "Finishing"],
  ),

  ExpoCategory(
    id: "textile-materials",
    name: "Textile Materials",
    title: "Textile Materials Innovation Expo 2026",
    description:
        "Textile fibers, yarns, fabrics, raw materials, technical "
        "textiles and next-generation textile materials.",
    tags: ["Fiber", "Yarn", "Fabric", "Materials", "Technical Textile"],
  ),

  ExpoCategory(
    id: "garments-automation",
    name: "Garments Automation",
    title: "Garments Automation Innovation Expo 2026",
    description:
        "Automation, smart manufacturing, machinery, robotics, "
        "digital production and garment technology.",
    tags: [
      "Automation",
      "Robotics",
      "Machinery",
      "Smart Manufacturing",
      "Garments",
    ],
  ),

  ExpoCategory(
    id: "green-sustech",
    name: "Green & SusTech",
    title: "Green & SusTech Innovation Expo 2026",
    description:
        "Green technology and sustainable solutions for the textile "
        "and RMG industry.",
    tags: [
      "Sustainability",
      "Green Technology",
      "Energy",
      "Water",
      "Circular Economy",
    ],
  ),
];

// ============================================================
// HALL
// ============================================================

class ExpoHall {
  const ExpoHall({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.capacityInfo,
    required this.features,
  });

  final String id;
  final String name;
  final String title;
  final String description;
  final String capacityInfo;
  final List<String> features;
}

const expoHalls = <ExpoHall>[
  ExpoHall(
    id: "hall-a",
    name: "Hall A",
    title: "Hall A – Main Exhibition Hall",
    description:
        "Main exhibition area featuring machinery, garment and "
        "apparel, raw materials, chemicals and sustainability exhibits.",
    capacityInfo: "300+ Booths",
    features: [
      "Machinery & Technology Booths 1–150",
      "Garment & Apparel Booths 151–220",
      "Raw Materials & Chemicals Booths 221–280",
      "Sustainability Pavilion Booths 281–300",
    ],
  ),

  ExpoHall(
    id: "hall-b",
    name: "Hall B",
    title: "Hall B – Innovation & Future Tech",
    description:
        "Innovation and technology zone featuring smart textiles, "
        "Industry 4.0 solutions and startup innovations.",
    capacityInfo: "50+ Emerging Textile Startups",
    features: [
      "Smart Textile & Industry 4.0 Zone",
      "Live Demonstrations",
      "AI-powered Solutions",
      "Startup & Innovation Pavilion",
    ],
  ),
];

// ============================================================
// FLOOR PLAN ZONES
// ============================================================

class FloorPlanZone {
  const FloorPlanZone({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  final String id;
  final String name;
  final String type;
  final String description;
}

const floorPlanZones = <FloorPlanZone>[
  FloorPlanZone(
    id: "exhibition-booths",
    name: "Exhibition Booths",
    type: "Exhibition",
    description:
        "Main exhibition booths distributed throughout the expo halls.",
  ),

  FloorPlanZone(
    id: "innovation-zone",
    name: "Innovation Zone",
    type: "Innovation",
    description:
        "Dedicated area for innovation and future textile technologies.",
  ),

  FloorPlanZone(
    id: "networking-lounge",
    name: "Networking Lounge",
    type: "Networking",
    description:
        "Dedicated networking area for visitors and industry professionals.",
  ),

  FloorPlanZone(
    id: "food-court",
    name: "Food Court",
    type: "Facility",
    description: "Food and refreshment area for expo visitors.",
  ),

  FloorPlanZone(
    id: "media-press",
    name: "Media & Press Area",
    type: "Media",
    description: "Dedicated area for media and press activities.",
  ),

  FloorPlanZone(
    id: "restrooms-prayer",
    name: "Restrooms & Prayer Room",
    type: "Facility",
    description: "Visitor facilities available within the venue.",
  ),
];

// ============================================================
// SESSION
// ============================================================

class Session {
  const Session({
    required this.id,
    required this.title,
    required this.type,
    required this.day,
    required this.start,
    required this.end,
    required this.hall,
    required this.speakerIds,
    required this.summary,
  });

  final String id;
  final String title;
  final String type;
  final int day;
  final String start;
  final String end;
  final String hall;
  final List<String> speakerIds;
  final String summary;
}

// Official detailed session schedule is not currently published.
//
// The visitors page mentions:
// "20+ technical sessions led by global experts"
// but individual session titles/times are not yet available.
//
// Do not use fictional session data.
const sessions = <Session>[];

// ============================================================
// VISITOR PROFILE
// ============================================================

class VisitorType {
  const VisitorType({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

const visitorTypes = <VisitorType>[
  VisitorType(
    id: "manufacturer",
    title: "Textile & Garment Manufacturers",
    description:
        "Manufacturers looking for new technologies, machinery, "
        "materials and sustainable production solutions.",
  ),

  VisitorType(
    id: "brand-owner",
    title: "Brand Owners & Retailers",
    description:
        "Brands and retailers looking for innovative textile "
        "products and supply-chain solutions.",
  ),

  VisitorType(
    id: "supply-chain",
    title: "Supply Chain Managers",
    description:
        "Professionals working across textile and garment supply chains.",
  ),

  VisitorType(
    id: "sustainability",
    title: "Sustainability Officers",
    description:
        "Professionals focused on sustainable and responsible textile production.",
  ),

  VisitorType(
    id: "technology-provider",
    title: "Technology Providers",
    description:
        "Technology companies showcasing solutions for the textile industry.",
  ),

  VisitorType(
    id: "consultant",
    title: "Industry Consultants",
    description:
        "Consultants and industry experts connecting with textile businesses.",
  ),

  VisitorType(
    id: "policy-academic",
    title: "Policy Makers & Academics",
    description:
        "Researchers, academics and policymakers exploring textile innovation.",
  ),

  VisitorType(
    id: "fashion-designer",
    title: "Fashion Designers",
    description:
        "Designers exploring new materials, technologies and sustainable textiles.",
  ),
];

// ============================================================
// NOTICE
// ============================================================

class Notice {
  const Notice(this.title, this.body);

  final String title;
  final String body;
}

const notices = <Notice>[
  Notice("TIExpo 2026 Dates", "12–14 November 2026, Thursday to Saturday."),

  Notice("Expo Hours", "Open daily from 10:00 AM to 6:00 PM."),

  Notice(
    "Venue",
    "International Convention City Bashundhara (ICCB), Dhaka, Bangladesh.",
  ),

  Notice("Entry", "Free for registered trade visitors."),

  Notice("Registration", "Pre-registration is mandatory for visitors."),

  Notice(
    "Exhibitor Directory",
    "The official exhibitor directory is coming soon.",
  ),

  Notice(
    "Technical Sessions",
    "20+ technical sessions are planned with global experts.",
  ),

  Notice(
    "Live Demonstrations",
    "Visitors can experience live machinery and factory innovation demonstrations.",
  ),
];

// ============================================================
// TRAVEL INFO
// ============================================================

class TravelInfo {
  static const venue = "International Convention City Bashundhara (ICCB)";

  static const address = "Kuril, Dhaka, Bangladesh";

  static const airport = "Hazrat Shahjalal International Airport (DAC)";

  static const accessibility = "Wheelchair accessible routes are available.";

  static const venueSupport =
      "Information desks are located at major entrances.";

  static const parking =
      "Venue parking information should be checked with ICCB.";
}

// ============================================================
// APP FILTERS
// ============================================================

const exhibitionFilters = <String>[
  "All",
  "Dyeing & Printing",
  "Textile Materials",
  "Garment Automation",
  "Green & SusTech",
];

const hallFilters = <String>["All", "Hall A", "Hall B"];

// ============================================================
// HELPER METHODS
// ============================================================

Speaker? speakerById(String id) {
  for (final speaker in speakers) {
    if (speaker.id == id) {
      return speaker;
    }
  }

  return null;
}

Exhibitor? exhibitorById(String id) {
  for (final exhibitor in exhibitors) {
    if (exhibitor.id == id) {
      return exhibitor;
    }
  }

  return null;
}

Session? sessionById(String id) {
  for (final session in sessions) {
    if (session.id == id) {
      return session;
    }
  }

  return null;
}

ExpoCategory? categoryById(String id) {
  for (final category in expoCategories) {
    if (category.id == id) {
      return category;
    }
  }

  return null;
}

ExpoHall? hallById(String id) {
  for (final hall in expoHalls) {
    if (hall.id == id) {
      return hall;
    }
  }

  return null;
}

List<Session> sessionsForSpeaker(String id) {
  return sessions.where((session) => session.speakerIds.contains(id)).toList();
}

List<Exhibitor> exhibitorsByCategory(String category) {
  return exhibitors
      .where((exhibitor) => exhibitor.category == category)
      .toList();
}

// ============================================================
// QUICK STATS
// ============================================================

class ExpoStats {
  static const visitors = "15,000+";
  static const exhibitors = "300+";
  static const sessions = "20+";
  static const halls = "2";
  static const days = "3";
}
