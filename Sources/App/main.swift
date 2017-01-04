import Vapor

let drop = Droplet()

drop.get { req in
  return try drop.view.make("chat", [
  	"title": drop.localization[req.lang, "chat", "title"]
  ])
}

drop.run()
