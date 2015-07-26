import Foundation
import RxSwift

class Creature: Printable, Hashable, Equatable {
    static var autoIncrementID = 1

    let id: Int
    let configuration: CreatureConfiguration
    let world: World
    var location: Location
    var position: Position
    var targetPosition: Position {
        didSet {
            sendNext(self.targetPositionChanged, self.targetPosition)
        }
    }
    var isMoving = false
    var isDead = false {
        didSet {
            if isDead {
                println("Dead: \(self)")
                compositeDisposable.dispose()
                sendCompleted(hpChanged)
            }
        }
    }
    var hp: Int {
        didSet {
            sendNext(hpChanged, self.hp)
        }
    }
    var nutrition: Int {
        didSet {
            sendNext(nutritionChanged, self.nutrition)
        }
    }
    var agingCounter: Int = 0

    let compositeDisposable = CompositeDisposable()
    let targetPositionChanged = PublishSubject<Position>()
    let hpChanged = PublishSubject<Int>()
    let nutritionChanged = PublishSubject<Int>()

    var description: String {
        return "\(self.dynamicType)#\(id)"
    }

    var hashValue: Int {
        get {
            return description.hashValue
        }
    }

    class func defaultConfiguration() -> CreatureConfiguration {
        fatalError("configuration() has not been implemented")
    }

    required init(room: Room, configuration: CreatureConfiguration) {
        self.world = room.world
        self.location = room
        self.position = room.randomPosition()
        self.targetPosition = self.position
        self.configuration = configuration
        self.hp = configuration.initialHP
        self.nutrition = configuration.initialNutrition
        self.id = Creature.autoIncrementID++
    }

    convenience init(room: Room) {
        self.init(room: room, configuration: self.dynamicType.defaultConfiguration())
    }

    func imageName() -> String {
        fatalError("imageName() has not been implemented")
    }

    func run() {
        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.agingCheck()
            }
            >- compositeDisposable.addDisposable
    }

    func agingCheck() {
        agingCounter++

        if agingCounter > configuration.agingInterval {
            agingCounter = 0

            hp -= configuration.agingPoint

            if hp <= 0 {
                isDead = true
            }
        }
    }

    func killedBy(killer: Creature) {
        let lastHP = hp
        hp = 0
        isDead = true

        let lostNutrition = Int(ceil(Double(nutrition) / 2))
        nutrition -= lostNutrition

        killer.nutrition += lostNutrition
        killer.hp += lastHP / 2
    }

    func decompose() {
        println("Decompose: \(self)")
        world.removeCreature(self)

        if let room = location as? Room {
            room.addNutrition(nutrition)
        } else if let bridge = location as? Bridge {
            bridge.startRoom.addNutrition(nutrition)
        }
    }
}

func ==(lhs: Creature, rhs: Creature) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func ==(lhs: Creature.Type, rhs: Creature.Type) -> Bool {
    return NSStringFromClass(lhs).hashValue == NSStringFromClass(rhs).hashValue
}

func contains(sequence: [Creature.Type], type: Creature.Type) -> Bool {
    for t in sequence {
        if t == type {
            return true
        }
    }
    return false
}
