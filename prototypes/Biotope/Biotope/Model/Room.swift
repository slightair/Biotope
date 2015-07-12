import Foundation

struct Room: Location {
    enum Type {
        case Red, Green, Blue, Unknown
    }

    let type: Type
    let position: Position
    let size: Double
}