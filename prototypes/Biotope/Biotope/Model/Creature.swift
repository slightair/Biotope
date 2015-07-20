import Foundation
import RxSwift

class Creature: Printable {
    static var autoIncrementID = 1

    let id: Int
    let configuration: CreatureConfiguration

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
                sendCompleted(lifeSubject)
            }
        }
    }

    let targetPositionChanged = PublishSubject<Position>()
    let lifeSubject = PublishSubject<Int>()

    var description: String {
        return "\(self.dynamicType)#\(id)"
    }

    required init(room: Room, configuration: CreatureConfiguration) {
        self.location = room
        self.position = room.randomPosition()
        self.targetPosition = self.position
        self.configuration = configuration
        self.id = Creature.autoIncrementID++
    }

    convenience init(room: Room) {
        let configuration = CreatureConfiguration(speed: 0, sight: 0, isActive: false)

        self.init(room: room, configuration: configuration)
    }

    func imageName() -> String {
        fatalError("imageName() has not been implemented")
    }

    func run() {
        fatalError("run() has not been implemented")
    }

    func collisionTo(another: Creature) {
        fatalError("collisionTo(another: Creature) has not been implemented")
    }

    func killedBy(killer: Creature) {
        isDead = true
    }
}
