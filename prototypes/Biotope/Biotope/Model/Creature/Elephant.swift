import Foundation
import RxSwift

class Elephant: Creature {
    convenience init(room: Room) {
        let configuration = CreatureConfiguration(speed: 1, sight: 50)

        self.init(room: room, configuration: configuration)
    }

    override func imageName() -> String {
        return "elephant"
    }

    override func run() {
        GameScenePaceMaker.defaultPaceMaker.paceSubject
            >- subscribeNext { currentTime in
                if self.isMoving {
                    return
                }
                self.isMoving = true

                switch self.location {
                case let currentRoom as Room:
                    self.position = currentRoom.randomPosition()
                default:
                    return
                }
        }
    }
}
