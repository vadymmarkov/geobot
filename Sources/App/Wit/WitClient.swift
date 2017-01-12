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

  var headers: [HeaderKey: String] {
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
               context: Node) throws -> Response {
    var requestQuery = self.query

    query.forEach { key, value in
      requestQuery[key] = value
    }

    let uri = "\(baseUrl)\(path)"
    let json = try JSON(node: context)
    let body = try Body.data(json.makeBytes())

    return try drop.client.request(method, uri, headers: headers, query: requestQuery, body: body)
  }
}
