import Foundation

struct Bridge: Location {
    let startRoom: Room
    let endRoom: Room

    var position: Position {
        get {
            return Position(x: (startRoom.position.x + endRoom.position.x) / 2.0,
                            y: (startRoom.position.y + endRoom.position.y) / 2.0)
        }
    }
}
