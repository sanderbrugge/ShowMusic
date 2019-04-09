ShowMusic Code Challenge
---------

`ShowMusic` is a single-page application for displaying album playlists.

Provided is `ShowMusic.xcodeproj`. This is an empty project that links the `ShowMusicServices` module.  

## Service Module

`ShowMusicServices` has the following service calls:

```swift
final public class MusicLibrary {

    public static let shared: ShowMusicServices.MusicLibrary

    /// Downloads music library
    ///
    /// - Parameter completion: callback returning a Response entity. `success` case returns a JSON Data object. Otherwise an `error` is returned.
    public func downloadMusicLibraryDefinition(_ completion: @escaping (ShowMusicServices.Response) -> ())

    /// Downloads an album cover image for a given album identifier
    ///
    /// - Parameters:
    ///   - identifier: The album identifier
    ///   - completion: callback returning a Response entity. `success` case returns a JPG image Data object. Otherwise an `error` is returned.
    public func downloadAlbumCover(identifier: Int, _ completion: @escaping (ShowMusicServices.Response) -> ())
}

public enum Response {

    case success(Data)

    case failure(Error)
}
```

## API Definition
The JSON returned by `ShowMusicServices` playlists of albums.

```json
{
  "playlists": [{
      "title": "The Playlist's Title",
      "albums": [
        1, 8, 10, 12, 2
      ]
    },
    ...
  ],
  "albums": [{
      "id": 0,
      "title": "The Album's Title"
    },
    ...
  ]
}
```

The `albums` array contains the entire collection of `album` objects available. `Album` objects have an identifier `id` Integer and an album title `title` String.

The `playlists` array contains individual `playlist` objects representing a group of albums. The `playlist` has a `title` value and an array of `album identifiers`.


## Assignment
Create a single page application that downloads and displays the user's playlist. 

### Minimum Requirements
* The User Interface design should be horizontally scrollable rows of albums representing playlists. Playlists should scroll vertically. (mockup below). The title of the playlist should be above each row. There is an emphasis on good visual design, so the nicer it looks the better.
* The album art should be `150x150 pt` on the screen.
* There are some minor errors in the JSON data (strictly logical, not formatting). These should be treated appropriately.
* The titles of each album appear underneath the albums.

## Mockup
![Mockup](./readme/mockup.png)

## Misc

This exercise should not be incredibly complex or time consuming. If this was not the case, or the instructions were not clear, please provide feedback.