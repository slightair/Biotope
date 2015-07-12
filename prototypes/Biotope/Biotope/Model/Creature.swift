import Foundation
import RxSwift

class Creature {
    var location: Location
    var x: Double
    var y: Double

    let positionChanged = PublishSubject<(x: Double, y:Double)>()

    required init(location: Location, x: Double, y: Double) {
        self.location = location
        self.x = x
        self.y = y
    }

    func imageName() -> String {
        return "mushroom"
    }

    func start() {
        GameScenePaceMaker.defaultPaceMaker.paceSubject
            >- subscribeNext { currentTime in
                self.x += Double(random() % 10) * (random() % 2 == 0 ? -1 : 1)
                self.y += Double(random() % 10) * (random() % 2 == 0 ? -1 : 1)

                sendNext(self.positionChanged, (x: self.x, y: self.y))
            }
    }
}