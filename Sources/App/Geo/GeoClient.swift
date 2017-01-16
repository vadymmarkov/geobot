import Foundation
import Vapor
import HTTP

struct GeoClient {
  let baseUrl = "https://restcountries.eu/rest/v1"
  let drop: Droplet

  var headers: [HeaderKey: String] {
    return [
      "Accept" : "application/json",
      "Content-Type" : "application/json"
    ]
  }

  init(drop: Droplet) {
    self.drop = drop
  }

  // MARK: - API

  func country(by name: String) throws -> Country {
    guard let name = name.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      throw Failure.invalidParameters
    }

    let endpoint = "\(baseUrl)/name/\(name)"
    let response = try drop.client.get(endpoint, headers: headers)

    guard let json = response.json?.node.nodeArray?.first else {
      throw Failure.invalidResponse
    }

    return try Country(json: JSON(node: json))
  }
}

