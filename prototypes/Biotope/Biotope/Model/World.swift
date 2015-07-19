import Foundation

class World {
    let width: Double
    let height: Double
    let rooms: [Room]
    let bridges: [Bridge]
    let creatures: [Creature]

    init() {
        width = 2048
        height = 2048

        let room = Room(type: .Green, position: Position(x: 0, y: 0), size: 512)

        rooms = [room]

        bridges = [
        ]

        var creatures: [Creature] = []
        for i in 1...3 {
            creatures.append(Elephant(location: room, position: room.randomPosition()))
        }

        for i in 1...20 {
            creatures.append(Mushroom(location: room, position: room.randomPosition()))
        }

        self.creatures = creatures
    }

    func run() {
        for creature in creatures {
            creature.start()
        }
    }
}