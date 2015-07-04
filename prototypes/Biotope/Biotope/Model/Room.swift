import Foundation

class Room {
    enum Type {
        case Red, Green, Blue, Unknown
    }

    let type : Type
    let x : Int
    let y : Int
    let size : Int
    let creatures : [Creature]

    init (type: Type, x: Int, y: Int, size: Int) {
        self.type = type
        self.x = x
        self.y = y
        self.size = size

        self.creatures = [Creature](count: 5, repeatedValue: Creature())
    }
}