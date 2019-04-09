import Foundation
import UIKit

extension UIView {
    /**
     * An extension function to apply a gradient backgroundColor to a view.
     *
     * - Parameter colors: an array of UIColor to use
     */
    public func setGradientLayer(with colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        
        layer.insertSublayer(gradient, at: 0)
    }
}
