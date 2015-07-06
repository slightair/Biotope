import Foundation

class World {
    let width : Int
    let height : Int
    let rooms : [Room]
    let bridges : [Bridge]

    init () {
        width = 2048
        height = 2048

        let redRoom = Room(type: .Red, x: 0, y: 192, size: 256)
        let greenRoom = Room(type: .Green, x: -192, y: -192, size: 256)
        let blueRoom = Room(type: .Blue, x: 192, y: -192, size: 256)

        rooms = [redRoom, greenRoom, blueRoom]

        bridges = [
            Bridge(startRoom: redRoom, endRoom: greenRoom),
            Bridge(startRoom: greenRoom, endRoom: blueRoom),
        ]
    }
}