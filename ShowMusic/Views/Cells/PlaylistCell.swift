import UIKit

class PlaylistCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    // make private for separation of concerns
    @IBOutlet private weak var albums: UICollectionView!
}

/**
 * Add an extension to set the delegate and data source of the collectionview in the tablecell.
 * This way the collectionview knows what data to display.
 * As explained in HomeViewController In a larger application I would extract the collectionview to a seperate ViewController and
 * delegate the data to there via segues.
 */
extension PlaylistCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        albums.delegate = dataSourceDelegate
        albums.dataSource = dataSourceDelegate
        albums.tag = row
        albums.setContentOffset(albums.contentOffset, animated: false)
        albums.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { albums.contentOffset.x = newValue }
        get { return albums.contentOffset.x }
    }
}
