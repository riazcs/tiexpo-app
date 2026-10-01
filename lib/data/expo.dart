class ExpoInfo {
  static const name = "TIExpo";
  static const fullName = "Textile Innovation Expo";
  static const edition = "2026";
  static const city = "Dhaka";
  static const venue = "Bangabandhu Textile Hall";
  static const datesLabel = "12–14 November 2026";
  static const days = <(int, String)>[
    (1, "Thu 12 Nov"),
    (2, "Fri 13 Nov"),
    (3, "Sat 14 Nov"),
  ];
}

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
  final String id, name, title, org, bio, initials, tone;
}

class Exhibitor {
  const Exhibitor({
    required this.id,
    required this.name,
    required this.category,
    required this.booth,
    required this.hall,
    required this.blurb,
    required this.tags,
  });
  final String id, name, category, booth, hall, blurb;
  final List<String> tags;
}

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
  final String id, title, type, start, end, hall, summary;
  final int day;
  final List<String> speakerIds;
}

class Notice {
  const Notice(this.title, this.body);
  final String title, body;
}

const speakers = <Speaker>[
  Speaker(
    id: "amara-sen",
    name: "Dr. Amara Sen",
    title: "Director of Smart Fibers",
    org: "MIT Materials Lab",
    bio:
        "Leads research on sensing yarns that measure heat, strain, and moisture without bulky electronics.",
    initials: "AS",
    tone: "copper",
  ),
  Speaker(
    id: "kenji-okada",
    name: "Kenji Okada",
    title: "Master Weaver & Technologist",
    org: "Kyoto Weave Lab",
    bio: "Bridges centuries-old Jacquard craft with programmable looms.",
    initials: "KO",
    tone: "pine",
  ),
  Speaker(
    id: "lina-hoss",
    name: "Lina Höss",
    title: "Circular Systems Lead",
    org: "EU Textile Pact",
    bio: "Designs closed-loop take-back programs that return fiber to mill grade.",
    initials: "LH",
    tone: "ink",
  ),
  Speaker(
    id: "priya-raman",
    name: "Priya Raman",
    title: "Founder",
    org: "Digital Jacquard",
    bio: "Ships CAD-to-loom pipelines used by mills from Coimbatore to Porto.",
    initials: "PR",
    tone: "copper",
  ),
  Speaker(
    id: "marcus-hale",
    name: "Marcus Hale",
    title: "Chief Scientist",
    org: "Pigment Co",
    bio: "Rebuilds industrial dye houses around microbial color.",
    initials: "MH",
    tone: "pine",
  ),
  Speaker(
    id: "nour-elsayed",
    name: "Nour El-Sayed",
    title: "Fiber Agronomist",
    org: "Desert Flax Initiative",
    bio: "Grows climate-hardy bast fibers on saline land.",
    initials: "NE",
    tone: "ink",
  ),
  Speaker(
    id: "sofia-ruiz",
    name: "Sofia Ruiz",
    title: "Wearables Architect",
    org: "ThreadForm",
    bio: "Integrates washable circuits into knitwear.",
    initials: "SR",
    tone: "copper",
  ),
  Speaker(
    id: "tomas-silva",
    name: "Tomás Silva",
    title: "Head of Recycled Denim",
    org: "CircuYarn",
    bio: "Turns post-consumer jeans into warp-ready yarns.",
    initials: "TS",
    tone: "pine",
  ),
];

const exhibitors = <Exhibitor>[
  Exhibitor(
    id: "looma",
    name: "Looma Labs",
    category: "Smart textiles",
    booth: "A12",
    hall: "Hall A",
    blurb: "Conductive knits and wash-cycle certified sensing panels.",
    tags: ["e-textiles", "knit"],
  ),
  Exhibitor(
    id: "threadform",
    name: "ThreadForm",
    category: "Wearables",
    booth: "A18",
    hall: "Hall A",
    blurb: "Clinical-grade garments with snap-out electronics.",
    tags: ["health", "knitwear"],
  ),
  Exhibitor(
    id: "circuyarn",
    name: "CircuYarn",
    category: "Recycling",
    booth: "B04",
    hall: "Hall B",
    blurb: "Mechanical recycle that keeps staple length for apparel.",
    tags: ["circular", "denim"],
  ),
  Exhibitor(
    id: "atlas-looms",
    name: "Atlas Looms",
    category: "Machinery",
    booth: "B21",
    hall: "Hall B",
    blurb: "Compact Jacquard frames with cloud pattern libraries.",
    tags: ["looms", "CAD"],
  ),
  Exhibitor(
    id: "pigment-co",
    name: "Pigment Co",
    category: "Color",
    booth: "C07",
    hall: "Hall B",
    blurb: "Bio-dyes matched to mill recipes, not just lab swatches.",
    tags: ["dye", "water"],
  ),
  Exhibitor(
    id: "weaveos",
    name: "WeaveOS",
    category: "Software",
    booth: "A03",
    hall: "Hall A",
    blurb: "Production OS connecting design, loom, and QC.",
    tags: ["software", "MES"],
  ),
  Exhibitor(
    id: "desert-flax",
    name: "Desert Flax",
    category: "Fiber",
    booth: "C12",
    hall: "Hall B",
    blurb: "Bast fiber from saline plots with mill-ready specs.",
    tags: ["flax", "climate"],
  ),
  Exhibitor(
    id: "nona-silk",
    name: "Nona Silk",
    category: "Luxury",
    booth: "F02",
    hall: "Forum",
    blurb: "Peace silk and peace-process finishing for couture houses.",
    tags: ["silk", "craft"],
  ),
  Exhibitor(
    id: "helix-knit",
    name: "Helix Knit",
    category: "Knit systems",
    booth: "A27",
    hall: "Hall A",
    blurb: "Whole-garment machines tuned for technical yarns.",
    tags: ["knit", "machines"],
  ),
  Exhibitor(
    id: "river-finish",
    name: "River Finish",
    category: "Finishing",
    booth: "B16",
    hall: "Hall B",
    blurb: "Closed-loop wash and enzyme finish for mills.",
    tags: ["finish", "water"],
  ),
];

const sessions = <Session>[
  Session(
    id: "opening-keynote",
    title: "The Cloth That Thinks",
    type: "Keynote",
    day: 1,
    start: "09:30",
    end: "10:20",
    hall: "Atrium",
    speakerIds: ["amara-sen"],
    summary: "Sensing yarns that leave the lab and survive a washing machine.",
  ),
  Session(
    id: "loom-language",
    title: "A Common Language for Looms",
    type: "Talk",
    day: 1,
    start: "10:40",
    end: "11:20",
    hall: "Hall A",
    speakerIds: ["kenji-okada", "priya-raman"],
    summary: "Open pattern files that mills can run without a floor translator.",
  ),
  Session(
    id: "circular-panel",
    title: "When Take-Back Actually Works",
    type: "Panel",
    day: 1,
    start: "13:00",
    end: "14:00",
    hall: "Forum",
    speakerIds: ["lina-hoss", "tomas-silva"],
    summary: "Brands, mills, and collectors on fiber that returns as fiber.",
  ),
  Session(
    id: "dye-workshop",
    title: "Microbial Color on the Floor",
    type: "Workshop",
    day: 1,
    start: "14:30",
    end: "16:30",
    hall: "Hall B",
    speakerIds: ["marcus-hale"],
    summary: "Hands-on dye baths. Limited to 40 seats.",
  ),
  Session(
    id: "desert-fiber",
    title: "Growing Cloth in Salt",
    type: "Talk",
    day: 2,
    start: "09:30",
    end: "10:15",
    hall: "Hall A",
    speakerIds: ["nour-elsayed"],
    summary: "Field data from saline plots and mill specs.",
  ),
  Session(
    id: "wearable-clinic",
    title: "Washable Circuits",
    type: "Talk",
    day: 2,
    start: "10:40",
    end: "11:25",
    hall: "Hall A",
    speakerIds: ["sofia-ruiz"],
    summary: "Garments that survive 50 wash cycles.",
  ),
  Session(
    id: "denim-loop",
    title: "Warp-Ready Recycled Denim",
    type: "Talk",
    day: 2,
    start: "13:00",
    end: "13:45",
    hall: "Hall B",
    speakerIds: ["tomas-silva"],
    summary: "Keeping staple length so recycled yarn can still hold a warp.",
  ),
  Session(
    id: "cad-workshop",
    title: "CAD to Loom in One Afternoon",
    type: "Workshop",
    day: 2,
    start: "14:00",
    end: "16:30",
    hall: "Hall A",
    speakerIds: ["priya-raman"],
    summary: "Bring a motif. Leave with a loom-ready file.",
  ),
  Session(
    id: "policy-panel",
    title: "Traceability Without Theater",
    type: "Panel",
    day: 3,
    start: "09:30",
    end: "10:30",
    hall: "Forum",
    speakerIds: ["lina-hoss", "kenji-okada", "marcus-hale"],
    summary: "Digital product passports mills can fill without a second ERP.",
  ),
  Session(
    id: "floor-tour",
    title: "Hall A Machinery Tour",
    type: "Tour",
    day: 3,
    start: "11:00",
    end: "12:00",
    hall: "Hall A",
    speakerIds: ["priya-raman"],
    summary: "Walk the live looms with Atlas and Helix operators.",
  ),
  Session(
    id: "closing",
    title: "What We Weave Next",
    type: "Keynote",
    day: 3,
    start: "15:00",
    end: "15:45",
    hall: "Atrium",
    speakerIds: ["amara-sen", "nour-elsayed"],
    summary: "Climate fiber, sensing cloth, and mill-ready research.",
  ),
];

const notices = <Notice>[
  Notice("Registration opens 08:00", "Badge pickup at the Atrium west desk."),
  Notice("Dye workshop is waitlisted", "Overflow seating opens 10 minutes before start."),
  Notice("Shuttle from Motijheel", "Every 20 minutes from 07:30. Last return 19:00."),
];

Speaker? speakerById(String id) {
  for (final s in speakers) {
    if (s.id == id) return s;
  }
  return null;
}

Exhibitor? exhibitorById(String id) {
  for (final e in exhibitors) {
    if (e.id == id) return e;
  }
  return null;
}

Session? sessionById(String id) {
  for (final s in sessions) {
    if (s.id == id) return s;
  }
  return null;
}

List<Session> sessionsForSpeaker(String id) =>
    sessions.where((s) => s.speakerIds.contains(id)).toList();
