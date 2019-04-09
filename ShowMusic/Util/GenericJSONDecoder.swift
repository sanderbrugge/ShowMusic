import Foundation

/**
 Generic class for fetching and decoding JSON responses.
 Models that use this class are expected to be conform with the Codable protocol.
 */
class GenericJSONDecoder {
    private let decoder = JSONDecoder()
    
    /**
     * Constructor, since it's from JSON initialize the decoding strategy with snake_case
     */
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    /**
     * Generic function to decode response data to a generic model struct that conforms to the Codable protocol.
     *
     * returns an array of objects
     */
    public func decodeToArray<T: Codable>(data: Data) -> [T]? {
        do {
            let decodedValues = try decoder.decode([T].self, from: data)
            return decodedValues
        } catch let err {
            print("error occured: \(err)")
            return nil
        }
    }
    
    /**
     * Generic function to decode response data to a generic model struct that conforms to the Codable protocol.
     *
     * returns an object
     */
    public func decodeToObject<T: Codable>(data: Data) -> T? {
        do {
            let decodedValue = try decoder.decode(T.self, from: data)
            return decodedValue
        } catch let err {
            print("error occured: \(err)")
            return nil
        }
}
}
