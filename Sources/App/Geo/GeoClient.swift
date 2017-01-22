import Foundation
import Vapor
import HTTP
import SwiftyCurl

struct GeoClient {

  enum Failure: Error {
    case invalidParameters
    case invalidResponse
  }

  let baseUrl = "https://restcountries.eu/rest/v1"
  let drop: Droplet

  var headers: [String: String] {
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

    let url = "\(baseUrl)/name/\(name)"
    let curlClient = CURLClient()
    let data = try curlClient.request(.get, url: url, headers: headers)

    guard let json = data.node.nodeArray?.first else {
      throw Failure.invalidResponse
    }

    return try Country(json: JSON(node: json))
  }
}

