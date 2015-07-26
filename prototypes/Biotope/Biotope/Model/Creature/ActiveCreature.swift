import Foundation
import RxSwift

class ActiveCreature: Creature {
    class func targets() -> [Creature.Type] {
        fatalError("targets() has not been implemented")
    }

    override func run() {
        super.run()

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                if let target = self.foundTarget() {
                    self.startHunting(target)
                    return
                }

                if self.isMoving {
                    return
                }
                self.isMoving = true

                if self.location is Room {
                    self.wanderInRoom()
                }
            }
            >- compositeDisposable.addDisposable
    }

    func collisionTo(another: Creature) {
        if isTarget(another) && !another.isDead {
            another.killedBy(self)
        }
    }

    func foundTarget() -> Creature? {
        if self.location is Room {
            let visibleCreatures = Array(world.creatures)
                .filter { self.isTarget($0) }
                .filter { !$0.isDead }
                .map { ($0, self.position.distanceTo($0.position)) }
                .filter { $0.1 < self.configuration.sight }
                .sorted { $0.1 < $1.1 }

            if let nearestCreatureTuple = visibleCreatures.first {
                return nearestCreatureTuple.0;
            }
        }
        return nil
    }

    func isTarget(creature: Creature) -> Bool {
        return contains(self.dynamicType.targets(), creature.dynamicType.self)
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
