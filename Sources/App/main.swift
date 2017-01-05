import Vapor
import Sessions

let memorySessions = MemorySessions()
let sessionsMiddleware = SessionsMiddleware(sessions: memorySessions)

let drop = Droplet()
drop.addConfigurable(middleware: sessionsMiddleware, name: "sessions")

// MARK: - HTTP

drop.get { req in
  return try drop.view.make("chat", [
  	"title": drop.localization[req.lang, "chat", "title"]
  ])
}

// MARK: - Sockets

let chat = Chat()

drop.socket("chat") { request, ws in
  let session = try request.session()
  session.data["geobot"] = "connected"
  var id = session.identifier

  ws.onText = { ws, text in
    let json = try JSON(bytes: Array(text.utf8))

    if let id = id, let message = json.object?["message"]?.string {
      chat.joinIfNeeded(id: id, ws: ws)
      try chat.send(id: id, message: "You asked me: \(message)")
    }
  }

  ws.onClose = { ws, _, _, _ in
    guard let id = id else {
      return
    }

    chat.connections.removeValue(forKey: id)
  }
}

// MARK: - App

drop.run()
