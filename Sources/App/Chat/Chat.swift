import Vapor

class Chat {
  var connections: [String: WebSocket] = [:]

  func joinIfNeeded(id: String, ws: WebSocket) {
    guard connections[id] == nil else {
      return
    }

    connections[id] = ws
  }

  func send(id: String, node: Node) throws {
    guard let connection = connections[id] else {
      return
    }

    let json = try JSON(node: node).serialize().string()
    try connection.send(json)
  }
}
