import Foundation

struct Bridge: Location {
    let startRoom: Room
    let endRoom: Room

    var x: Double {
        get {
            return (startRoom.x + endRoom.x) / 2.0
        }
    }

    var y: Double {
        get {
            return (startRoom.y + endRoom.y) / 2.0
        }
    }
}
