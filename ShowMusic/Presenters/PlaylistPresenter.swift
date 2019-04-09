import Foundation
import ShowMusicServices

class PlaylistPresenter {
    private let decoder = GenericJSONDecoder()
    private let showMusicServices: MusicLibrary
    private weak var homeProtocol: HomeProtocol?
    
    /**
     * Constructor, sets the service.
     */
    init(showMusicServices: MusicLibrary) {
        self.showMusicServices = showMusicServices
    }
    
    /**
     * attach a view that extends the HomeProtocol, so we can send updates the the view.
     */
    public func attachView(homeProtocol: HomeProtocol) {
        self.homeProtocol = homeProtocol
    }
    
    /**
     * Get the playlists and albums from the API, decode the json to the model if succesful.
     * set error if not succesful.
     * Update the subscribed view through the homeProtocol callback fn's
     */
    public func getPlaylists() {
        homeProtocol?.startLoading()
        showMusicServices.downloadMusicLibraryDefinition {[weak self] response in
            self?.homeProtocol?.finishLoading()
            
            switch(response){
            case .success(let data):
                guard let showMusicData: ShowMusicData = self?.decoder.decodeToObject(data: data) else {
                    self?.homeProtocol?.setError(message: "Something went wrong")
                    return
                }
                
                self?.homeProtocol?.setData(data: showMusicData)
                
            case .failure(let error):
                self?.homeProtocol?.setError(message: error.localizedDescription)
            }
        }
    }
}
