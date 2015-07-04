import Foundation

class World {
    let width : Int
    let height : Int
    let rooms : [Room]

    init () {
        width = 2048
        height = 2048

        rooms = [
            Room(type: .Red, x: 0, y: 192, size: 256),
            Room(type: .Green, x: -192, y: -192, size: 256),
            Room(type: .Blue, x: 192, y: -192, size: 256),
        ]
    }
}