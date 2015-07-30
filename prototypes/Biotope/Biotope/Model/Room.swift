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
    var emergingStepCount = 0
    let nutritionChanged = PublishSubject<Int>()
    let compositeDisposable = CompositeDisposable()

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

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { interval in
                self.emergingStepCount++
                if self.emergingStepCount > self.configuration.emergingStepCountInterval {
                    self.emergeCreatures()
                    self.emergingStepCount = 0
                }
            }
            >- compositeDisposable.addDisposable
    }

    deinit {
        compositeDisposable.dispose()
    }

    func randomPosition() -> Position {
        let radius = Double(arc4random_uniform(UInt32(configuration.size / 2))) * 0.8
        let radian = 2 * M_PI / 128 * Double(arc4random_uniform(128))

        return Position(x: radius * cos(radian), y: radius * sin(radian))
    }

    func addNutrition(nutrition: Int) {
        self.nutrition += nutrition
    }

    func emergeCreatures() {
        for i in 0..<configuration.emergingMaxCount {
            let needle = arc4random_uniform(UInt32(configuration.emergingCreatures.count))
            let type = configuration.emergingCreatures[Int(needle)]
            let needNutrition = type.defaultConfiguration().initialNutrition

            let emerge = arc4random_uniform(4) == 0 && needNutrition <= nutrition
            if emerge {
                nutrition -= needNutrition
                let creature = type(room: self, isBorn: false)
                world.emergeCreature(creature)
            }
        }
    }
}