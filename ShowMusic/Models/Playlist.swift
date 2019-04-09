/**
 * Playlist model that conforms to Codable to deserialize data to it.
 * We can assume that this data will always be available
 */
struct Playlist: Codable {
    public private(set) var title: String
    public private(set) var albums: [Int]
}
