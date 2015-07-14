import Foundation

struct Bridge: Location {
    let startRoom: Room
    let endRoom: Room

    var position: Position {
        get {
            return Position.centerOf(startRoom.position, endRoom.position)
        }
    }
}
