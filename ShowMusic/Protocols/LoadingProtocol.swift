/**
 * Base protocol for easy expansion. Decided on these 3 functions that will always be present
 * in a view controller that handles data fetching and displaying.
 *
 * This serves as a parent protocol that can be extended.
 */
protocol LoadingProtocol: class {
    func startLoading()
    func finishLoading()
    func setError(message: String)
}
