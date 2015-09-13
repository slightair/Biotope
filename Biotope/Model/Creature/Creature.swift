import Foundation
import RxSwift

class Creature: CustomStringConvertible, Hashable {
    static let DrainNutritionRange: UInt = 2
    static let WanderCandidateRange: UInt = 3

    static var autoIncrementID = 1

    enum WalkStatus {
        case Idle, Wander, FoundTarget
    }

    enum Action {
        case Eat
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

    var walkStatus: WalkStatus = .Idle {
        didSet {
            sendNext(walkStatusChanged, walkStatus)
        }
    }
    let walkStatusChanged = PublishSubject<WalkStatus>()

    var targetPathFinder: PathFinder?

    let actionCompleted = PublishSubject<Action>()

    var isBorn = false {
        didSet {
            if isBorn {
                print("Born: \(self)")
                start()
            }
        }
    }

    var isDead = false {
        didSet {
            if isDead {
                print("Dead: \(self)")
                compositeDisposable.dispose()
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

    var agingIntervalCounter: Int = 0
    var actionIntervalCounter: Int = 0
    var moveIntervalCounter: Int = 0

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
                if self.actionIntervalCounter > 0 {
                    self.actionIntervalCounter--
                    return
                }
                self.actionIntervalCounter = self.configuration.actionInterval

                let result = self.drainNutrition()
                if result {
                    sendNext(self.actionCompleted, .Eat)
                }
            }
            >- compositeDisposable.addDisposable
    }

    func setUpConsumer1Action() {
        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.moveToNextPoint()

                if self.moveIntervalCounter > 0 {
                    self.moveIntervalCounter--
                    return
                }

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

    func moveToNextPoint() {
        if let pathFinder = targetPathFinder {
            switch pathFinder.nextPoint() {
            case .Point(let cell):
                currentCell = cell
            case .End:
                targetPathFinder = nil
                walkStatus = .Idle
                moveIntervalCounter = configuration.moveInterval
            }
        }
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
        if agingIntervalCounter > 0 {
            agingIntervalCounter--
            return
        }
        agingIntervalCounter = configuration.agingInterval

        hp -= configuration.agingPoint
        if hp <= 0 {
            isDead = true
        }
    }

    func drainNutrition() -> Bool {
        let targetCells = currentCell.world.areaCells(center: currentCell, distance: Creature.DrainNutritionRange, includeCenter: true)

        var drainedNutrition = 0
        let drainPower = configuration.actionPower
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

        let prevTargetPathFinder = targetPathFinder
        targetPathFinder = pathFinder
        walkStatus = .FoundTarget
        if prevTargetPathFinder == nil {
            moveToNextPoint()
        }
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
        moveToNextPoint()
    }

    func collisionTo(another: Creature) {
        if isTarget(another) {
            another.killedBy(self)
            sendNext(actionCompleted, .Eat)
        }
    }

    func isTarget(creature: Creature) -> Bool {
        return configuration.trophicLevel.targetLevel() == creature.configuration.trophicLevel && creature.isBorn && !creature.isDead
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
        print("Decompose: \(self)")
        currentCell.world.removeCreature(self)

        let splashTargets = currentCell.world.areaCells(center: currentCell, distance: 1, includeCenter: true)
        var distribution = [Int](count: splashTargets.count, repeatedValue: 0)
        for _ in 0..<nutrition {
            let destination = Int(arc4random_uniform(UInt32(splashTargets.count)))
            distribution[destination]++
        }

        for (index, target) in splashTargets.enumerate() {
            target.addNutrition(distribution[index])
        }
    }
}

func ==(lhs: Creature, rhs: Creature) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
