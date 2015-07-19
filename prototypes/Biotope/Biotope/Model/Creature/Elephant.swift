import Foundation
import RxSwift

class Elephant: Creature {
    convenience init(room: Room) {
        let configuration = CreatureConfiguration(speed: 1, sight: 50)

        self.init(room: room, configuration: configuration)
    }

    override func imageName() -> String {
        return "elephant"
    }

    override func run() {
        GameScenePaceMaker.defaultPaceMaker.paceSubject
            >- subscribeNext { currentTime in
                if let target = self.foundTarget() {
                    self.startHunting(target)
                    return
                }

                if self.isMoving {
                    return
                }
                self.isMoving = true

                switch self.location {
                case let currentRoom as Room:
                    self.wanderInRoom()
                default:
                    return
                }
        }
    }

    func foundTarget() -> Creature? {
        switch self.location {
        case let currentRoom as Room:
            let world = currentRoom.world
            let visibleCreatures = world.creatures
                .filter { $0 is Mushroom }
                .map { ($0, self.position.distanceTo($0.position)) }
                .filter { $0.1 < self.configuration.sight }
                .sorted { $0.1 < $1.1 }

            if let nearestCreatureTuple = visibleCreatures.first {
                return nearestCreatureTuple.0;
            }
            return nil
        default:
            return nil
        }
    }

    func startHunting(target: Creature) {
        self.targetPosition = target.position
    }

    func wanderInRoom() {
        if let currentRoom = self.location as? Room {
            self.targetPosition = currentRoom.randomPosition()
        }
    }
}
