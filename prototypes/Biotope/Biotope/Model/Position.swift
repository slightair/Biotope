import UIKit

struct Position {
    var x: Double
    var y: Double

    static func centerOf(left: Position, _ right: Position) -> Position {
        return Position(x: (left.x + right.x) / 2.0,
                        y: (left.y + right.y) / 2.0)
    }

    var CGPointValue: CGPoint {
        get {
            return CGPointMake(CGFloat(x), CGFloat(y))
        }
    }
}
