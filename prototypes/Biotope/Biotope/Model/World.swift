import Foundation

class World {
    let width: Double
    let height: Double
    var rooms: [Room]
    var bridges: [Bridge]
    var creatures: [Creature]

    init() {
        width = 2048
        height = 2048

        rooms = []
        bridges = []
        creatures = []
    }

    func construct() {
        let room = Room(type: .Green, position: Position(x: 0, y: 0), size: 512, world: self)

        rooms = [room]

        bridges = [
        ]

        var creatures: [Creature] = []
        for i in 1...3 {
            creatures.append(Elephant(room: room))
        }

        for i in 1...20 {
            creatures.append(Mushroom(room: room))
        }

        self.creatures = creatures
    }

    func run() {
        for creature in creatures {
            creature.run()
        }
    }
}