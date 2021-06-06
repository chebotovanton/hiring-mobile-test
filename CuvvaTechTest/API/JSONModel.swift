import Foundation

// MARK: JSONDecoder config

let apiJsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()

    // WIP. Do I need any other configuration here?
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return jsonDecoder
}()


// MARK: JSON Response Decodable

typealias JSONResponse = [JSONEvent]

// WIP. Not sure about Identifiable here. There are no good id candidates in returned JSON
struct JSONEvent: Decodable/*, Identifiable*/ {

    // WIP. What to do with the id?
//    let id: String

    let type: String
    let payload: JSONPayload
}

// WIP. It would be nice to handle non-existing parameters in a more elegant way
struct JSONPayload: Decodable {
    let policyId: String
    let vehicle: JSONVehicle?
    let timestamp: Date
    let startDate: Date?
    let endDate: Date?
}

struct JSONVehicle: Decodable {
    let prettyVrm: String
    let make: String
    let model: String

    //WIP. Do I need the rest of this info?
    //"prettyVrm": "MA77 GRO",
    //        "make": "Volkswagen",
    //        "model": "Polo",
    //        "variant": "SE 16V",
    //        "color": "Silver",
    //        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non."

}
