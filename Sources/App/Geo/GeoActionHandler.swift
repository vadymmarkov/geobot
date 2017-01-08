import Vapor

struct GeoActionHandler: ConverseActionHandler {
  let drop: Droplet
  let client: GeoClient

  init(drop: Droplet) {
    self.drop = drop
    self.client = GeoClient(drop: drop)
  }

  func handleAction(on converse: Converse, context: Node) -> Node {
    guard let action = converse.action else {
      return context
    }

    var context = context

    switch action {
    case "findCapital":
      context = capital(from: converse, context: &context)
    default:
      break
    }

    return context
  }

  func capital(from converse: Converse, context: inout Node) -> Node {
    if let countryEntities = converse.entities?["country"]?.array,
      !countryEntities.isEmpty,
      let value = countryEntities[0].object?["value"]?.string
    {
      if let country = try? client.country(by: value) {
        context["capital"] = Node.string(country.capital)
      } else {
        context["notFound"] = true
      }
    } else {
      context["missingCountry"] = true
    }

    return context
  }
}
