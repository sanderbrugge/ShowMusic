import Foundation
import UIKit
import ShowMusicServices

class HomeViewController: UITableViewController {
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingViewText: UILabel!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    
    fileprivate let playlistPresenter = PlaylistPresenter(showMusicServices: MusicLibrary.shared)
    fileprivate var showMusicData = ShowMusicData()
    fileprivate var collectionViewOffsets = [Int: CGFloat]()
    
    private let thumbnailImage = ThumbnailImageCache()
    
    /*
     * change the statusbar' font color to white
     */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
     * initialize the presenter and start the fetching of data
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistPresenter.attachView(homeProtocol: self)
        playlistPresenter.getPlaylists()
    }
    
    /**
     * Add the loading view and error view as a subview on tap of the tableview, with the same width and height as the tableview.
     * set them hidden by default and use the protocol's callback fn's to show appropriate subscreens.
     */
    private func drawLoadingAndErrorView() {
        tableView?.addSubview(loadingView)
        tableView?.addSubview(errorView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        tableView?.addConstraints([
            loadingView.widthAnchor.constraint(equalTo: (tableView?.widthAnchor)!),
            loadingView.heightAnchor.constraint(equalTo: (tableView?.heightAnchor)!),
            errorView.widthAnchor.constraint(equalTo: (tableView?.widthAnchor)!),
            errorView.heightAnchor.constraint(equalTo: (tableView?.heightAnchor)!)
            ])
        activityIndicator.hidesWhenStopped = true
        loadingView.isHidden = true
        errorView.isHidden = true
    }
    
    fileprivate func setLoadingViewVisibility(hidden: Bool) {
        loadingView.isHidden = hidden
        
        guard hidden else {
            activityIndicator.startAnimating()
            return
        }
        
        activityIndicator.stopAnimating()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMusicData.playlists?.count ?? 0
    }
    
    /**
     * I had set the height in the storyboard, but it generated a warning and wouldn't apply my height,
     * this fixes that.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistCell
        
        cell.title.text = showMusicData.playlists?[indexPath.row].title
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        return cell
    }
    
    /**
     * Make sure the collectionview that's being scrolled keeps it's offset, but doesn't reflect on reused cells.
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let playlistCell = cell as? PlaylistCell else { return }
        
        
        playlistCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        playlistCell.collectionViewOffset = collectionViewOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let playlistCell = cell as? PlaylistCell else { return }

         collectionViewOffsets[indexPath.row] = playlistCell.collectionViewOffset
    }
    
}

/**
 * CollectionView delegate and DataSource to set and display the correct data in the horizontal lists.
 * In a larger application I'd extract this out to a separate viewcontroller and delegate the data through segues.
 * for this usecase I find that the extension works just fine.
 */
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showMusicData.playlists?[collectionView.tag].albums.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let albumId = showMusicData.playlists![collectionView.tag].albums[indexPath.row]
        
        collectionCell.setGradientLayer(with: [ColorConstants.darkPurple, ColorConstants.darkPinkRed, ColorConstants.lightBlue])
        
        guard let album = getAlbumInPlaylist(with: albumId) else {
            collectionCell.title.text = "This album is removed"
            collectionCell.thumbnail.image = UIImage(named: "placeholder")
            return collectionCell
        }
        
        collectionCell.title.text = album.title
        thumbnailImage.getAlbumCover(by: albumId, view: collectionCell.thumbnail)
        
        return collectionCell
    }
    
    /**
     * Get the album that's linked to the playlist by Id
     * - Parameter id: the album's id.
     */
    private func getAlbumInPlaylist(with id: Int) -> Album? {
        return showMusicData.albums!.first(where: { $0.id == id })
    }
}

/**
 * I like the way the MVP pattern in conjuction with protocol based classes solve the so called 'Massive View Controller' problem.
 * By making the ViewControllers part of the view layer and not something in between. They just know they'll get data and what to do with it
 * This way we extract de responsibility of data fetching, parsing, error handling, ... to the presenter-layer and just use callback fn's
 * to update the viewcontroller.
 */
extension HomeViewController: HomeProtocol {
    func setData(data: ShowMusicData) {
        DispatchQueue.main.async {
            self.showMusicData = data
            self.tableView.reloadData()
        }
    }
    
    func startLoading() {
        drawLoadingAndErrorView()
        setLoadingViewVisibility(hidden: false)
    }
    
    func finishLoading() {
        DispatchQueue.main.async {
            self.setLoadingViewVisibility(hidden: true)
        }
    }
    
    func setError(message: String) {
        DispatchQueue.main.async {
            self.errorView.isHidden = false
            self.errorMessage.text = message
        }
    }
}
