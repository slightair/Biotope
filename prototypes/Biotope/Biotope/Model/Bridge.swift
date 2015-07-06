import Foundation

class Bridge {
    let startRoom : Room
    let endRoom : Room

    init(startRoom: Room, endRoom: Room) {
        self.startRoom = startRoom
        self.endRoom = endRoom
    }
}
