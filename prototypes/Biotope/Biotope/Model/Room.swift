import Foundation

class Room {
    enum RoomType {
        case Red, Green, Blue, Unknown
    }

    let type : RoomType
    let x: Int
    let y: Int
    let size: Int

    init (type: RoomType, x: Int, y: Int, size: Int) {
        self.type = type
        self.x = x
        self.y = y
        self.size = size
    }
}