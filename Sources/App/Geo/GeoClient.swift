import Foundation
import Vapor

struct GeoClient {
  let baseUrl = "https://restcountries.eu/rest/v1/"
  let drop: Droplet

  init(drop: Droplet) {
    self.drop = drop
  }

  func country(by name: String) throws -> Country {
    let name = name.lowercased()
    let response = try drop.client.get("capital/\(name)")

    guard let json = response.json else {
      throw Failure.invalidResponse
    }

    return try Country(json: json)
  }
}

