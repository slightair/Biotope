import Foundation
import RxSwift

class Creature {
    var location: Location
    var position: Position {
        didSet {
            sendNext(self.positionChanged, self.position)
        }
    }
    var isMoving = false

    let moveTiming = PublishSubject<CFTimeInterval>()

    let positionChanged = PublishSubject<Position>()

    required init(location: Location, position: Position) {
        self.location = location
        self.position = position
    }

    func imageName() -> String {
        return "mushroom"
    }

    func start() {
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