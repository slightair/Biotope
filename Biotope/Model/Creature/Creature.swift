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

    let compositeDisposable = CompositeDisposable()

    var description: String {
        return "\(self.dynamicType)#\(id)"
    }

    init(currentCell: Cell) {
        self.currentCell = currentCell
        self.targetPathFinder = nil
        self.id = Creature.autoIncrementID++
    }

    func start() {
        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                if self.targetPathFinder != nil {
                    return
                }
                self.findNewTarget()
            }
            >- compositeDisposable.addDisposable
    }

    func findNewTarget() {
        let world = currentCell.world
        let targetCell = world.randomCell(center: currentCell, distance: 3)
        let pathFinder = PathFinder(source: currentCell, destination: targetCell)
        pathFinder.calculate()

        targetPathFinder = pathFinder
    }
}
