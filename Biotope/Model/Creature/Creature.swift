import Foundation
import RxSwift

class Creature {
    var currentCell: Cell {
        didSet {
            sendNext(currentCellChanged, currentCell)
        }
    }
    let currentCellChanged = PublishSubject<Cell>()
    let compositeDisposable = CompositeDisposable()
    var counter = 0

    init(currentCell: Cell) {
        self.currentCell = currentCell
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
