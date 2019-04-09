import UIKit
import ShowMusicServices

/**
 * 'download' and cache the images in memory.
 * Usually I'd expect to get url's to the albums art-work. When that's the case I'm inclined to use SD_WebImage
 * for it's ease of use and not re-inventing the wheel.
 *
 * However, since the service returns the image's data I implemented this helper class to fetch and cache the images.
 * I don't feel like this is a good practice, but it's the best I could come up with after trying multiple approaches.
 *
 * This is based on a Hackernoon post by Andy Wong: https://hackernoon.com/ios-image-caching-swift-4-22471342e6c1
 */
class ThumbnailImageCache {
    private let coverCache = NSCache<AnyObject, AnyObject>()
    
    public func getAlbumCover(by id: Int, view: UIImageView) {
        
        view.image = UIImage(named: "placeholder")
        
        if let imageInCache = coverCache.object(forKey: id as AnyObject) as? UIImage {
            view.image = imageInCache
            return
        }
        
        MusicLibrary.shared.downloadAlbumCover(identifier: id) {[weak self] response in
            switch (response) {
            case .success(let data):
                DispatchQueue.main.async {
                    
                    // Since they're high res images I scale them down by 60% to save resources
                    let image = UIImage(data: data, scale: 0.4)!
                    self?.coverCache.setObject(image as AnyObject, forKey: id as AnyObject)
                    view.image = image
                    
                }
            case .failure:
                DispatchQueue.main.async {
                    let image = UIImage(named: "placeholder")
                    self?.coverCache.setObject(image as AnyObject, forKey: id as AnyObject)
                    view.image = image
                }
            }
        }
    }
}
