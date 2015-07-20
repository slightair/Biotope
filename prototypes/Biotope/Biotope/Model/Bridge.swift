import Foundation

func ==(lhs: Bridge, rhs: Bridge) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct Bridge: Location, Printable, Hashable, Equatable {
    let startRoom: Room
    let endRoom: Room

    var description: String {
        get {
            return "\(startRoom)/\(endRoom)/"
        }
    }

    var hashValue: Int {
        get {
            return description.hashValue
        }
    }

    var position: Position {
        get {
            return Position.centerOf(startRoom.position, endRoom.position)
        }
    }
}
