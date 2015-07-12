import Foundation
import RxSwift

class Creature {
    var location: Location
    var position: Position

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
                self.position.x += Double(random() % 10) * (random() % 2 == 0 ? -1 : 1)
                self.position.y += Double(random() % 10) * (random() % 2 == 0 ? -1 : 1)

                sendNext(self.positionChanged, self.position)
            }
    }
}