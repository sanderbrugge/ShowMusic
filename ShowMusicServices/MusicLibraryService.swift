//
//  ShowMusicService.swift
//  ShowMusicServices
//
//  Created by Dave Henke on 8/10/18.
//  Copyright © 2018 ShowPad, NV. All rights reserved.
//

import Foundation

public enum Response {
    case success(Data)
    case failure(Error)
}

final public class MusicLibrary {
    
    static private let bundleErrorCode: Int = 500
    static private let bundleError: String = "Failed to find bundled data or the bundle itself. This should never happen."
    static private let bundleId = "com.musicapp.ShowMusicServices"
    
    static private let imageNotFoundErrorCode: Int = 404
    static private let imageNotFoundError: String = "Image not found"
    
    public static let shared = MusicLibrary()
    
    
    /// Downloads music library
    ///
    /// - Parameter completion: callback returning a Response entity. `success` case returns a JSON Data object. Otherwise an `error` is returned.
    public func downloadMusicLibraryDefinition(_ completion: @escaping (Response) -> ()) {
        let delayInterval = TimeInterval(arc4random() % 10)
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + delayInterval) {
            guard let bundle = Bundle(identifier: MusicLibrary.bundleId), let path = bundle.path(forResource: "data", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                completion(Response.failure(NSError(domain: MusicLibrary.bundleId, code: MusicLibrary.bundleErrorCode, userInfo: [NSLocalizedDescriptionKey : MusicLibrary.bundleError])))
                return
            }
            completion(Response.success(data))
        }
    }
    
    
    /// Downloads an album cover image for a given album identifier
    ///
    /// - Parameters:
    ///   - identifier: The album identifier
    ///   - completion: callback returning a Response entity. `success` case returns a JPG image Data object. Otherwise an `error` is returned.
    public func downloadAlbumCover(identifier: Int, _ completion: @escaping (Response) -> ()) {
        let delayInterval = TimeInterval(arc4random() % 10)
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + delayInterval) {
            guard let bundle = Bundle(identifier: MusicLibrary.bundleId) else {
                completion(Response.failure(NSError(domain: MusicLibrary.bundleId, code: MusicLibrary.bundleErrorCode, userInfo: [NSLocalizedDescriptionKey : MusicLibrary.bundleError])))
                return
            }
            guard let path = bundle.path(forResource: "\(identifier)", ofType: "jpg"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                completion(Response.failure(NSError(domain: MusicLibrary.bundleId, code: MusicLibrary.imageNotFoundErrorCode, userInfo: [NSLocalizedDescriptionKey : MusicLibrary.imageNotFoundError])))
                return
            }
            completion(Response.success(data))
        }
    }
}
