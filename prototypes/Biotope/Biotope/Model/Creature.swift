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

    let positionChanged = PublishSubject<Position>()

    init(location: Location, position: Position) {
        self.location = location
        self.position = position
    }

    func imageName() -> String {
        fatalError("imageName() has not been implemented")
    }

    func start() {
        fatalError("start() has not been implemented")
    }
}
