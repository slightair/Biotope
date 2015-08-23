import Foundation
import RxSwift

class World {
    let EmergingStepCountInterval = 10
    let EmergingProbability = 0.25

    let map: TMXMap
    var cells: [Cell]!
    var creatures: Set<Creature> = []
    var emergingStepCount = 0
    let creatureEmerged = PublishSubject<Creature>()
    let compositeDisposable = CompositeDisposable()

    init(named name: String) {
        self.map = TMXMapLoader.load(name)

        setUpCells()
        setUpCreatures()
    }

    deinit {
        compositeDisposable.dispose()
    }

    func setUpCells() {
        var cells: [Cell] = []

        for index in 0..<(self.map.width * self.map.height) {
            let cell = Cell(world: self, index: index)
            cells.append(cell)

            let bonus = arc4random_uniform(4)
            cell.nutrition += Int(bonus)
        }

        var index = 0
        for y in 0..<self.map.height {
            for x in 0..<self.map.width {
                let cell = cells[index]

                if 0 < x && x < self.map.width {
                    cell[.Left] = cells[index - 1]
                }
                if 0 <= x && x < self.map.width - 1 {
                    cell[.Right] = cells[index + 1]
                }

                if y % 2 == 0 {
                    if 0 <= x && x < self.map.width && 0 < y && y < self.map.height - 1 {
                        cell[.LeftTop] = cells[index - self.map.width]
                    }
                    if 0 <= x && x < self.map.width - 1 && 0 < y && y < self.map.height - 1 {
                        cell[.RightTop] = cells[index - self.map.width + 1]
                    }
                    if 0 <= x && x < self.map.width && 0 <= y && y < self.map.height - 1 {
                        cell[.LeftBottom] = cells[index + self.map.width]
                    }
                    if 0 <= x && x < self.map.width - 1 && 0 <= y && y < self.map.height - 1 {
                        cell[.RightBottom] = cells[index + self.map.width + 1]
                    }
                } else {
                    if 0 <= x && x < self.map.width && 0 < y && y < self.map.height {
                        cell[.RightTop] = cells[index - self.map.width]
                    }
                    if 0 < x && x < self.map.width && 0 < y && y < self.map.height {
                        cell[.LeftTop] = cells[index - self.map.width - 1]
                    }
                    if 0 < x && x < self.map.width && 0 < y && y < self.map.height - 1 {
                        cell[.LeftBottom] = cells[index + self.map.width - 1]
                    }
                    if 0 <= x && x < self.map.width && 0 < y && y < self.map.height - 1 {
                        cell[.RightBottom] = cells[index + self.map.width]
                    }
                }
                index++
            }
        }
        self.cells = cells
    }

    func setUpCreatures() {
        for _ in 1...3 {
            let creature = Creature(cell: randomCell(), configuration: CreatureConfiguration.AC01)
            creatures.insert(creature)
        }

        for _ in 1...20 {
            let creature = Creature(cell: randomCell(), configuration: CreatureConfiguration.NAC01)
            creatures.insert(creature)
        }
    }

    func start() {
        for creature in creatures {
            creature.start()
        }

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { interval in
                self.emergingStepCount++
                if self.emergingStepCount > self.EmergingStepCountInterval {
                    self.emergeCreatures()
                    self.emergingStepCount = 0
                }
                self.printDebugInfo()
            }
            >- compositeDisposable.addDisposable
    }

    func randomCell() -> Cell {
        let needle = Int(arc4random_uniform(UInt32(cells.count)))
        return cells[needle]
    }

    func randomCell(#center: Cell, distance: UInt) -> Cell {
        let candidates = areaCells(center: center, distance: distance)
        let needle = Int(arc4random_uniform(UInt32(candidates.count)))
        return candidates[needle]
    }

    func areaCells(#center: Cell, distance: UInt, includeCenter: Bool = false) -> [Cell] {
        var cells: Set<Cell> = []
        var newCells: [Cell] = [center]

        for _ in 0..<distance {
            let prevCells = newCells
            newCells = []

            for prevCell in prevCells {
                for direction in Cell.Direction.values {
                    if let foundCell = prevCell[direction] {
                        if foundCell != center {
                            cells.insert(foundCell)
                            newCells.append(foundCell)
                        }
                    }
                }
            }
        }

        if includeCenter {
            cells.insert(center)
        }

        return Array(cells)
    }

    func searchTargetCell(#center: Cell, distance: UInt, targetLevel: CreatureConfiguration.TrophicLevel) -> Cell? {
        let candidateCells = areaCells(center: center, distance: distance)
        var candidateCreatures: [Creature] = []

        for creature in creatures {
            if !contains(candidateCells, creature.currentCell) {
                continue
            }
            if creature.isDead {
                continue
            }
            if !creature.isBorn {
                continue
            }
            if creature.configuration.trophicLevel != targetLevel {
                continue
            }
            candidateCreatures.append(creature)
        }

        let targetCells = candidateCreatures.map { $0.currentCell }
                                            .sorted { center.distance($0) < center.distance($1) }
        return targetCells.first
    }

    func searchEmptyCellsFrom(cells: [Cell]) -> [Cell] {
        var checkCells = cells
        for creature in creatures {
            if checkCells.count == 0 {
                break
            }

            if let index = find(checkCells, creature.currentCell) {
                checkCells.removeAtIndex(index)
            }
        }

        return checkCells
    }

    func addCreature(#configuration: CreatureConfiguration, cell: Cell) {
        let creature = Creature(cell: cell, configuration: configuration, isBorn: false)
        creatures.insert(creature)
        sendNext(creatureEmerged, creature)
    }

    func emergeCreatures() {
        for cell in cells {
            let newCreatureConfiguration = CreatureConfiguration.NAC01
            let needNutrition = newCreatureConfiguration.initialNutrition
            let emerge = Double(arc4random_uniform(1000)) < 1000 * EmergingProbability &&
                         needNutrition <= cell.nutrition &&
                         !(Array(creatures).filter { $0.currentCell == cell }.count > 0)

            if emerge {
                cell.nutrition -= needNutrition
                addCreature(configuration: newCreatureConfiguration, cell: cell)
            }
        }
    }

    func removeCreature(creature: Creature) {
        self.creatures.remove(creature)
    }

    func printDebugInfo() {
        let creaturesArray = Array(creatures)
        var nutrition = cells.map { $0.nutrition }.reduce(0, combine: +) +
            creaturesArray.map { $0.nutrition }.reduce(0, combine: +)

        let producerCount = creaturesArray.filter { $0.configuration.trophicLevel == .Producer }.count
        let consumer1Count = creaturesArray.filter { $0.configuration.trophicLevel == .Consumer1 }.count
        println("nutrition: \(nutrition), producer: \(producerCount), consumer1: \(consumer1Count)")
    }
}
