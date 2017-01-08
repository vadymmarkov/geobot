import JSON

struct Country: JSONInitializable {
  let name: String
  let capital: String
  let region: String
  let subregion: String
  let population: Int
  let area: Int
  let languages: [String]

  init(json: JSON) throws {
    name = try json.extract("name")
    capital = try json.extract("capital")
    region = try json.extract("region")
    subregion = try json.extract("subregion")
    population = try json.extract("population")
    area = try json.extract("area")
    languages = try json.extract("languages")
  }
}
