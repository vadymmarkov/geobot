import Vapor
import HTTP

protocol WitClient {
  var drop: Droplet { get }
  var config: WitConfig { get }
}

extension WitClient {

  // MARK: - Configs

  var baseUrl: String {
    return "https://api.wit.ai/"
  }

  var headers: [String: String] {
    return [
      "Authorization" : "Bearer \(config.token)",
      "Accept" : "application/json",
      "Content-Type" : "application/json"
    ]
  }

  var query: [String: CustomStringConvertible] {
    return [
      "v": config.version,
      "session_id": config.sessionId
    ]
  }

  // MARK: - API

  func request(_ method: Method,
               path: String,
               query: [String: CustomStringConvertible] = [:],
               context: Node) throws -> JSON {
    var requestQuery = self.query

    query.forEach { key, value in
      requestQuery[key] = value
    }

    let url = "\(baseUrl)\(path)"
    let json = try JSON(node: context)
    let curlClient = CURLClient()
    
    return try curlClient.request(method, url: url, query: requestQuery, headers: headers, body: json)
  }
}
