import Vapor
import HTTP

enum Failure: Error {
  case invalidResponse
}

protocol ConverseActionHandler {
  func handleAction(on converse: Converse, context: Node) -> Node
}

final class ConverseClient: WitClient {
  typealias ConverseCallback = (Node) throws -> Void

  let path = "converse"
  let drop: Droplet
  let config: WitConfig
  let actionHandler: ConverseActionHandler

  init(drop: Droplet, config: WitConfig, actionHandler: ConverseActionHandler) {
    self.drop = drop
    self.config = config
    self.actionHandler = actionHandler
  }

  // MARK: - API

  func post(message: String? = nil, context: Node = Node.object([:]), callback: ConverseCallback) throws {
    var query: [String: CustomStringConvertible] = [:]

    if let message = message {
      query["q"] = message
    }

    let response = try request(.post, path: path, query: query, context: context)

    guard let json = response.json else {
      throw Failure.invalidResponse
    }

    let converse = try Converse(json: json)

    switch converse.type {
    case .action:
      let context = actionHandler.handleAction(on: converse, context: context)
      try post(context: context, callback: callback)
    case .message:
      if let answer = converse.message {
        var node = Node.object([
          "message": Node.string(answer)
        ])

        if let quickReplies = converse.quickReplies {
          node["quickReplies"] = try quickReplies.makeNode()
        }

        try callback(node)
      }
      
      try post(context: context, callback: callback)
    case .stop:
      break
    }
  }
}
