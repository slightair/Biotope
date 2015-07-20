import Foundation

class World {
    let width: Double
    let height: Double
    var rooms: Set<Room>
    var bridges: Set<Bridge>
    var creatures: Set<Creature>

    init() {
        width = 2048
        height = 2048

        rooms = []
        bridges = []
        creatures = []
    }

    func construct() {
        let room = Room(world: self, type: .Green, position: Position(x: 0, y: 0), size: 512)

        rooms = [room]

        bridges = [
        ]

        var creatures: Set<Creature> = []
        for i in 1...3 {
            creatures.insert(Elephant(room: room))
        }

        for i in 1...20 {
            creatures.insert(Mushroom(room: room))
        }

        self.creatures = creatures
    }

    func run() {
        for creature in creatures {
            creature.run()
        }
    }

    func removeCreature(creature: Creature) {
        self.creatures.remove(creature)
    }
}