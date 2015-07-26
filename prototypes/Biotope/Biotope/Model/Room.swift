import Foundation
import RxSwift

func ==(lhs: Room, rhs: Room) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Room: Location, Printable, Hashable, Equatable {
    enum Type {
        case Red, Green, Blue, Unknown
    }

    let world: World
    let type: Type
    let position: Position
    let size: Double
    var nutrition = 0 {
        didSet {
            sendNext(nutritionChanged, self.nutrition)
        }
    }
    let nutritionChanged = PublishSubject<Int>()

    var description: String {
        get {
            return "\(world)/\(type)/\(position)/\(size)/"
        }
    }

    var hashValue: Int {
        get {
            return description.hashValue
        }
    }

    init(world: World, type: Type, position: Position, size: Double) {
        self.world = world
        self.type = type
        self.position = position
        self.size = size
    }

    func randomPosition() -> Position {
        let radius = Double(arc4random_uniform(UInt32(size / 2))) * 0.8
        let radian = 2 * M_PI / 128 * Double(arc4random_uniform(128))

        return Position(x: radius * cos(radian), y: radius * sin(radian))
    }

    func addNutrition(nutrition: Int) {
        self.nutrition += nutrition
    }
}