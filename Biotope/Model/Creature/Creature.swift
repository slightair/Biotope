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
    let compositeDisposable = CompositeDisposable()
    var counter = 0

    var description: String {
        return "\(self.dynamicType)#\(id)"
    }

    init(currentCell: Cell) {
        self.currentCell = currentCell
        self.id = Creature.autoIncrementID++
    }

    func start() {
        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.counter++

                if self.counter % 2 == 0 {
                    var directionIndex = Int(arc4random_uniform(UInt32(Cell.Direction.values.count)))
                    var nextCell: Cell?
                    do {
                        let direction = Cell.Direction(rawValue: directionIndex % Cell.Direction.values.count)!
                        nextCell = self.currentCell[direction]
                        directionIndex++
                    } while nextCell == nil
                    self.currentCell = nextCell!
                }
            }
            >- compositeDisposable.addDisposable
    }
}
