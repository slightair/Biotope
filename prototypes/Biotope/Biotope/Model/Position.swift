import UIKit
import Swift

struct Position: Printable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    init(point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
    }

    static func centerOf(left: Position, _ right: Position) -> Position {
        return Position(x: (left.x + right.x) / 2.0,
                        y: (left.y + right.y) / 2.0)
    }

    func distanceTo(another: Position) -> Double {
        let distX = another.x - x
        let distY = another.y - y

        return sqrt(distX * distX + distY * distY)
    }

    var CGPointValue: CGPoint {
        get {
            return CGPointMake(CGFloat(x), CGFloat(y))
        }
    }

    var description: String {
        return String(format: "%.2f, %.2f", x, y)
    }
}
