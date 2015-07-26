import Foundation
import RxSwift

func ==(lhs: Room, rhs: Room) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Room: Location, Printable, Hashable, Equatable {
    let world: World
    let configuration: RoomConfiguration
    var nutrition: Int {
        didSet {
            sendNext(nutritionChanged, self.nutrition)
        }
    }
    let nutritionChanged = PublishSubject<Int>()

    var position: Position {
        get {
            return configuration.position
        }
    }

    var description: String {
        get {
            return "\(world)/\(configuration.type)/\(configuration.position)/\(configuration.size)/"
        }
    }

    var hashValue: Int {
        get {
            return description.hashValue
        }
    }

    init(world: World, configuration: RoomConfiguration) {
        self.world = world
        self.configuration = configuration
        self.nutrition = configuration.initialNutrition
    }

    func randomPosition() -> Position {
        let radius = Double(arc4random_uniform(UInt32(configuration.size / 2))) * 0.8
        let radian = 2 * M_PI / 128 * Double(arc4random_uniform(128))

        return Position(x: radius * cos(radian), y: radius * sin(radian))
    }

    func addNutrition(nutrition: Int) {
        self.nutrition += nutrition
    }
}