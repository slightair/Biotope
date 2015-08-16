import Foundation
import RxSwift

class Creature: Printable, Hashable {
    static var autoIncrementID = 1

    enum WalkStatus {
        case Idle, Wander, FoundTarget
    }

    let id: Int
    var currentCell: Cell {
        didSet {
            sendNext(currentCellChanged, currentCell)
        }
    }
    let currentCellChanged = PublishSubject<Cell>()

    let configuration: CreatureConfiguration

    var walkStatus: WalkStatus = .Idle

    var targetPathFinderSubscription: Disposable?
    var targetPathFinder: PathFinder? {
        didSet {
            sendNext(targetPathFinderChanged, targetPathFinder)

            if targetPathFinderSubscription != nil {
                targetPathFinderSubscription?.dispose()
            }

            if targetPathFinder != nil && targetPathFinder!.hasRoute {
                targetPathFinderSubscription = zip(from(targetPathFinder!.result!), GameScenePaceMaker.defaultPaceMaker.pace) { $0.0 }
                    >- subscribe { event in
                        switch event {
                        case .Next(let cell):
                            self.currentCell = cell.value
                        case .Error(let error):
                            fallthrough
                        case .Completed():
                            self.targetPathFinder = nil
                            self.walkStatus = .Idle
                        }
                    }
            }
        }
    }
    let targetPathFinderChanged = PublishSubject<PathFinder?>()

    var isBorn = false {
        didSet {
            if isBorn {
                println("Born: \(self)")
                start()
            }
        }
    }

    var isDead = false {
        didSet {
            if isDead {
                println("Dead: \(self)")
                compositeDisposable.dispose()

                if targetPathFinderSubscription != nil {
                    targetPathFinderSubscription?.dispose()
                }

                sendCompleted(life)
            }
        }
    }

    var hp: Int {
        didSet {
            sendNext(life, self.hp)
        }
    }
    let life = PublishSubject<Int>()

    var nutrition: Int {
        didSet {
            sendNext(nutritionChanged, self.nutrition)
        }
    }
    let nutritionChanged = PublishSubject<Int>()

    var agingCounter: Int = 0

    let compositeDisposable = CompositeDisposable()

    var description: String {
        return "\(self.dynamicType)#\(id)"
    }

    var hashValue: Int {
        get {
            return description.hashValue
        }
    }

    init(cell: Cell, configuration: CreatureConfiguration, isBorn: Bool) {
        self.currentCell = cell
        self.configuration = configuration
        self.targetPathFinder = nil
        self.hp = configuration.initialHP
        self.nutrition = configuration.initialNutrition
        self.isBorn = isBorn

        self.id = Creature.autoIncrementID++
    }

    convenience init(cell: Cell, configuration: CreatureConfiguration) {
        self.init(cell: cell, configuration: configuration, isBorn: true)
    }

    func start() {
        if configuration.type == .Active {
            GameScenePaceMaker.defaultPaceMaker.pace
                >- subscribeNext { currentTime in
                    if self.walkStatus == .FoundTarget {
                        return
                    }

                    if let target = self.foundTarget() {
                        self.startHunting(target)
                        return
                    }

                    self.wander()
                }
                >- compositeDisposable.addDisposable
        }
    }

    func foundTarget() -> Cell? {
        let world = currentCell.world

        return world.searchTargetCell(center: currentCell, distance: configuration.sight, targetFamilies: configuration.food)
    }

    func startHunting(targetCell: Cell) {
        let pathFinder = PathFinder(source: currentCell, destination: targetCell)
        pathFinder.calculate()

        targetPathFinder = pathFinder
        walkStatus = .FoundTarget
    }

    func wander() {
        if walkStatus == .Wander {
            return
        }

        let world = currentCell.world
        let targetCell = world.randomCell(center: currentCell, distance: 3)
        let pathFinder = PathFinder(source: currentCell, destination: targetCell)
        pathFinder.calculate()

        targetPathFinder = pathFinder
        walkStatus = .Wander
    }

    func collisionTo(another: Creature) {
        if isTarget(another) {
            another.killedBy(self)
        }
    }

    func isTarget(creature: Creature) -> Bool {
        return contains(configuration.food, creature.configuration.family)
    }

    func killedBy(killer: Creature) {
        let lastHP = hp
        hp = 0
        isDead = true

//        let lostNutrition = Int(ceil(Double(nutrition) / 2))
//        nutrition -= lostNutrition
//
//        killer.nutrition += lostNutrition
        killer.hp += lastHP / 2
    }

    func decompose() {
        println("Decompose: \(self)")
        currentCell.world.removeCreature(self)

//        room.addNutrition(nutrition)
    }
}

func ==(lhs: Creature, rhs: Creature) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
