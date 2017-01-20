import Foundation
import Vapor
import Sessions
import HTTP

let memorySessions = MemorySessions()
let sessionsMiddleware = SessionsMiddleware(sessions: memorySessions)

let drop = Droplet()
drop.addConfigurable(middleware: sessionsMiddleware, name: "sessions")
//drop.client = FoundationClient.self

// MARK: - HTTP

drop.get { req in
  return try drop.view.make("chat", [
  	"title": drop.localization[req.lang, "chat", "title"]
  ])
}

// MARK: - Sockets

let chat = Chat()

drop.socket("chat") { request, ws in
  guard let token = drop.config["wit", "token"]?.string ?? Env.get("WIT_TOKEN") else {
    return
  }

  let id = UUID().uuidString

  let witConfig = WitConfig(
    token: token,
    version: "20160526",
    sessionId: id)

  let actionHandler = GeoActionHandler(drop: drop)
  let converseClient = ConverseClient(drop: drop, config: witConfig, actionHandler: actionHandler)

  ws.onText = { ws, text in
    let json = try JSON(bytes: Array(text.utf8))

    if let message = json.object?["message"]?.string {
      chat.joinIfNeeded(id: id, ws: ws)

      try converseClient.post(message: message) { answer in
        try chat.send(id: id, node: answer)
      }
    }
  }

  ws.onClose = { ws, _, _, _ in
    chat.connections.removeValue(forKey: id)
  }
}

// MARK: - App

drop.run()
