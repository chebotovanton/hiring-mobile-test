import Foundation

// MARK: JSONDecoder config

let apiJsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()

    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return jsonDecoder
}()


// MARK: JSON Response Decodable

typealias JSONResponse = [JSONEvent]

enum EventType: String, Decodable {
    case unknown
    case created
    case extended
    case cancelled
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case "policy_created": self = .created
        case "policy_extension": self = .extended
        case "policy_cancelled": self = .cancelled
        default: self = .unknown
        }
    }
}

// WIP. Not sure about Identifiable here. There are no good id candidates in returned JSON
struct JSONEvent: Decodable/*, Identifiable*/ {

//    let id: String

    let type: EventType
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
}
