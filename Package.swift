import PackageDescription

let package = Package(
  name: "geobot",
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 3),
    .Package(url: "https://github.com/vadymmarkov/SwiftyCurl", majorVersion: 0, minor: 6)
  ],
  exclude: [
    "Config",
    "Database",
    "Localization",
    "Public",
    "Resources",
    "Tests",
  ]
)
