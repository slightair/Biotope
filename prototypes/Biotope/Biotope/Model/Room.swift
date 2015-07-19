import Foundation

struct Room: Location {
    enum Type {
        case Red, Green, Blue, Unknown
    }

    let type: Type
    let position: Position
    let size: Double
    let world: World

    func randomPosition() -> Position {
        let radius = Double(arc4random_uniform(UInt32(size / 2))) * 0.8
        let radian = 2 * M_PI / 128 * Double(arc4random_uniform(128))

        return Position(x: radius * cos(radian), y: radius * sin(radian))
    }
}