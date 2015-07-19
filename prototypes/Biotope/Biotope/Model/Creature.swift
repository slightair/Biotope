import Foundation
import RxSwift

class Creature {
    let configuration: CreatureConfiguration

    var location: Location
    var position: Position {
        didSet {
            sendNext(self.positionChanged, self.position)
        }
    }
    var isMoving = false

    let positionChanged = PublishSubject<Position>()

    required init(room: Room, configuration: CreatureConfiguration) {
        self.location = room
        self.position = room.randomPosition()
        self.configuration = configuration
    }

    convenience init(room: Room) {
        let configuration = CreatureConfiguration(speed: 0, sight: 0)

        self.init(room: room, configuration: configuration)
    }

    func imageName() -> String {
        fatalError("imageName() has not been implemented")
    }

    func run() {
        fatalError("run() has not been implemented")
    }
}
