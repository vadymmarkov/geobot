import Foundation
import Vapor

struct GeoClient {
  let baseUrl = "https://restcountries.eu/rest/v1"
  let drop: Droplet

  init(drop: Droplet) {
    self.drop = drop
  }

  func country(by name: String) throws -> Country {
    let name = name.lowercased()
    let response = try drop.client.get("\(baseUrl)/name/\(name)")

    guard let json = response.json?.node.nodeArray?.first else {
      throw Failure.invalidResponse
    }

    return try Country(json: JSON(node: json))
  }
}

