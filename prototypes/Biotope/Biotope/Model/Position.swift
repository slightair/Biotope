import UIKit

struct Position {
    var x: Double
    var y: Double

    var CGPointValue: CGPoint {
        get {
            return CGPointMake(CGFloat(x), CGFloat(y))
        }
    }
}
