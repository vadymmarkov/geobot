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
      context = update(context: context, from: converse) { country, context -> Node in
        var context = context
        context["capital"] = Node.string(country.capital)
        return context
      }
    case "findSubregion":
      context = update(context: context, from: converse) { country, context -> Node in
        var context = context
        context["subregion"] = Node.string(country.subregion)
        return context
      }
    case "findPopulation":
      context = update(context: context, from: converse) { country, context -> Node in
        var context = context
        context["population"] = Node.string("\(country.population)")
        return context
      }
    case "findArea":
      context = update(context: context, from: converse) { country, context -> Node in
        var context = context
        context["area"] = Node.string("\(country.area)")
        return context
      }
    default:
      break
    }

    return context
  }

  func update(context: Node, from converse: Converse, update: (Country, Node) -> Node) -> Node {
    var context = context

    if var object = context.nodeObject {
      //object.removeValue(forKey: "notFound")
      //object.removeValue(forKey: "missingEntity")
      //context = Node(object)
    }

    if let value = extractCountry(from: converse) {
      if let country = try? client.country(by: value) {
        context = update(country, context)
      } else {
        context["notFound"] = true
      }
    } else {
      context["missingEntity"] = true
    }

    return context
  }

  func extractCountry(from converse: Converse) -> String? {
    guard let countryEntities = converse.entities?["country"]?.array,
      !countryEntities.isEmpty,
      let value = countryEntities[0].object?["value"]?.string
      else
    {
      return nil
    }

    return value
  }
}
