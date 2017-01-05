import Vapor

class Chat {
  var connections: [String: WebSocket] = [:]

  func joinIfNeeded(id: String, ws: WebSocket) {
    guard connections[id] == nil else {
      return
    }

    connections[id] = ws
  }

  func send(id: String, message: String) throws {
    guard let connection = connections[id] else {
      return
    }

    try connection.send(message)
  }
}
