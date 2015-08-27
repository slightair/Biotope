import Foundation
import RxSwift

class Creature: Printable, Hashable {
    static let DrainNutritionRange: UInt = 2
    static let WanderCandidateRange: UInt = 3

    static var autoIncrementID = 1

    enum WalkStatus {
        case Idle, Wander, FoundTarget
    }

    let id: Int
    var currentCell: Cell {
        willSet {
            for direction in Cell.Direction.values {
                if currentCell[direction] == newValue {
                    currentDirection = direction
                }
            }
        }
        didSet {
            sendNext(currentCellChanged, currentCell)
        }
    }
    let currentCellChanged = PublishSubject<Cell>()

    var currentDirection: Cell.Direction = .LeftBottom {
        didSet {
            sendNext(currentDirectionChanged, currentDirection)
        }
    }
    let currentDirectionChanged = PublishSubject<Cell.Direction>()

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

    let actionCompleted = PublishSubject<Bool>()

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
            sendNext(life, hp)
        }
    }
    let life = PublishSubject<Int>()

    var nutrition: Int {
        didSet {
            sendNext(nutritionChanged, nutrition)
        }
    }
    let nutritionChanged = PublishSubject<Int>()

    var agingCounter: Int = 0
    var actionCounter: Int = 0

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
        switch configuration.trophicLevel {
        case .Producer:
            setUpProducerAction()
        case .Consumer1:
            setUpConsumer1Action()
        case .Consumer2:
            setUpConsumer2Action()
        default:
            return
        }

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.breedCheck()
                self.agingCheck()
            }
            >- compositeDisposable.addDisposable
    }

    func setUpProducerAction() {
        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.actionCounter++
                if self.actionCounter > self.configuration.actionInterval {
                    self.actionCounter = 0

                    let result = self.drainNutrition()
                    sendNext(self.actionCompleted, result)
                }
            }
            >- compositeDisposable.addDisposable
    }

    func setUpConsumer1Action() {
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

    func setUpConsumer2Action() {
    }

    func breedCheck() {
        if nutrition < configuration.initialNutrition * 3 {
            return
        }

        let world = currentCell.world

        let candidateCells = world.searchEmptyCellsFrom(world.areaCells(center: currentCell, distance: 1))
        if candidateCells.count == 0 {
            return
        }

        let needle = Int(arc4random_uniform(UInt32(candidateCells.count)))
        let targetCell = candidateCells[needle]

        nutrition -= configuration.initialNutrition
        world.addCreature(configuration: configuration, cell: targetCell)
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

    func drainNutrition() -> Bool {
        let targetCells = currentCell.world.areaCells(center: currentCell, distance: Creature.DrainNutritionRange, includeCenter: true)

        var drainedNutrition = 0
        var drainPower = configuration.actionPower
        for target in targetCells {
            if target.nutrition > drainPower {
                target.nutrition -= drainPower
                drainedNutrition += drainPower
            } else {
                let remain = target.nutrition
                target.nutrition = 0
                drainedNutrition += remain
            }
        }
        nutrition += drainedNutrition

        return drainedNutrition > 0
    }

    func foundTarget() -> Cell? {
        let world = currentCell.world

        return world.searchTargetCell(center: currentCell, distance: configuration.sight, targetLevel: configuration.trophicLevel.targetLevel())
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
        let targetCell = world.randomCell(center: currentCell, distance: Creature.WanderCandidateRange)
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
        return configuration.trophicLevel.targetLevel() == creature.configuration.trophicLevel
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
        currentCell.world.removeCreature(self)

        let splashTargets = currentCell.world.areaCells(center: currentCell, distance: 1, includeCenter: true)
        var distribution = [Int](count: splashTargets.count, repeatedValue: 0)
        for _ in 0..<nutrition {
            let destination = Int(arc4random_uniform(UInt32(splashTargets.count)))
            distribution[destination]++
        }

        for (index, target) in enumerate(splashTargets) {
            target.addNutrition(distribution[index])
        }
    }
}

func ==(lhs: Creature, rhs: Creature) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
