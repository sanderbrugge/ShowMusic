/**
 * Album model that conforms to Codable to deserialize data to it.
 * We can assume that this data will always be available
 */
struct Album: Codable {
    public private(set) var id: Int
    public private(set) var title: String
}
