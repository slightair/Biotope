import Foundation

struct Room: Location {
    enum Type {
        case Red, Green, Blue, Unknown
    }

    let type: Type
    let x: Double
    let y: Double
    let size: Double
}