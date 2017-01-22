import Foundation
import SwiftyCurl
import URI
import JSON
import HTTP

struct CURLClient {

  enum Failure: Error {
    case invalidMethod
    case invalidResponse
  }

  func request(_ method: HTTP.Method,
               url: String,
               query: [String: CustomStringConvertible] = [:],
               headers: [String: String] = [:],
               body: JSON? = nil) throws -> JSON {
    guard let method = cURLRequestMethod(rawValue: method.description) else {
      throw Failure.invalidMethod
    }

    var uri = try URI(url)
    uri.append(query: query)

    var data: Data?

    if let body = body {
      data = Data.init(bytes: try body.makeBytes())
    }

    let url = try uri.makeFoundationURL()
    var request = cURLRequest(url: url, method: method, headers: headers, body: data)
    request.contentType = .json

    let connection = cURLConnection(useSSL: true)
    let response = try connection.request(request)

    guard let responseBody = response.rawBody else {
      throw Failure.invalidResponse
    }

    return try JSON.init(bytes: [UInt8](responseBody))
  }
}
