import Foundation
import RxSwift

class Creature {
    let configuration: CreatureConfiguration

    var location: Location
    var position: Position
    var targetPosition: Position {
        didSet {
            sendNext(self.targetPositionChanged, self.targetPosition)
        }
    }
    var isMoving = false

    let targetPositionChanged = PublishSubject<Position>()

    required init(room: Room, configuration: CreatureConfiguration) {
        self.location = room
        self.position = room.randomPosition()
        self.targetPosition = self.position
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
