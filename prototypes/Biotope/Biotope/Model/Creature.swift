import Foundation
import RxSwift

class Creature {
    var location: Location
    var x: Double
    var y: Double

    required init(location: Location, x: Double, y: Double) {
        self.location = location
        self.x = x
        self.y = y
    }

    func imageName() -> String {
        return "mushroom"
    }

    func start() {

    }
}