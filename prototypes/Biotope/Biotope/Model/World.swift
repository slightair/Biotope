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

        let room = Room(type: .Red, position: Position(x:0, y:0), size: 512)

        rooms = [room]

        bridges = [
        ]

        creatures = [
            Creature(location: room, position: Position(x:0, y:0)),
            Creature(location: room, position: Position(x:0, y:10)),
            Creature(location: room, position: Position(x:0, y:20)),
            Creature(location: room, position: Position(x:0, y:30)),
            Creature(location: room, position: Position(x:0, y:40)),
        ]
    }

    func run() {
        for creature in creatures {
            creature.start()
        }
    }
}