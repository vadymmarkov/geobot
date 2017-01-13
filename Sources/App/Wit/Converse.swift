import Foundation
import Vapor

public enum ConverseType: String {
  case action = "action"
  case message = "msg"
  case stop = "stop"
}

struct Converse: JSONInitializable {
  let type: ConverseType
  let action: String?
  let message: String?
  let entities: JSON?
  let quickReplies: [String]?
  let confidence: Double

  init(json: JSON) throws {
    type = try ConverseType(rawValue: json.extract("type"))!
    action = try json.extract("action")
    message = try json.extract("msg")
    entities = try json.extract("entities")
    confidence = try json.extract("confidence")
    quickReplies = try json.extract("quickreplies")
  }
}
