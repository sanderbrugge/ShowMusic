import Foundation

/**
 * HomeViewController specific actions that will happen.
 */
protocol HomeProtocol: LoadingProtocol {
    func setData(data: ShowMusicData)
}
