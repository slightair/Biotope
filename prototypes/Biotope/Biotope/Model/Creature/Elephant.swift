import Foundation
import RxSwift

class Elephant : Creature {
    override func imageName() -> String {
        return "elephant"
    }

    override func start() {
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
