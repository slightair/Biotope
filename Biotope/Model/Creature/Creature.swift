import Foundation
import RxSwift

class Creature: Printable {
    static var autoIncrementID = 1

    let id: Int
    var currentCell: Cell {
        didSet {
            sendNext(currentCellChanged, currentCell)
        }
    }
    let currentCellChanged = PublishSubject<Cell>()

    let configuration: CreatureConfiguration

    var targetPathFinder: PathFinder? {
        didSet {
            sendNext(targetPathFinderChanged, targetPathFinder)

            if targetPathFinder != nil && targetPathFinder!.hasRoute {
                zip(from(targetPathFinder!.result!), GameScenePaceMaker.defaultPaceMaker.pace) { $0.0 }
                    >- subscribe { event in
                        switch event {
                        case .Next(let cell):
                            self.currentCell = cell.value
                        case .Error(let error):
                            fallthrough
                        case .Completed():
                            self.targetPathFinder = nil
                        }
                    }
                    >- compositeDisposable.addDisposable
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
                    if self.targetPathFinder != nil {
                        return
                    }
                    self.findNewTarget()
                }
                >- compositeDisposable.addDisposable
        }
    }

    func findNewTarget() {
        let world = currentCell.world
        let targetCell = world.randomCell(center: currentCell, distance: 3)
        let pathFinder = PathFinder(source: currentCell, destination: targetCell)
        pathFinder.calculate()

        targetPathFinder = pathFinder
    }
}
