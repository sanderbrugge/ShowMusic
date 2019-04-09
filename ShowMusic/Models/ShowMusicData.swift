/**
 * base structure of the model, this data may not be present
 * extends Codable
 */
struct ShowMusicData: Codable {
    public private(set) var playlists: [Playlist]?
    public private(set) var albums: [Album]?
}
