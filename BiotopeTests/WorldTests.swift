import Foundation
import XCTest

class WorldTests: XCTestCase {
    var subject: World!

    override func setUp() {
        super.setUp()

        subject = World(named: "debug")
        subject.creatures.removeAll()
    }

    func testSearchEmptyCellsFrom() {
        //    84 -  85
        // 99 - 100 - 101
        //   116 - 117

        let searchCells = [
            subject.cells[84],
            subject.cells[85],
            subject.cells[99],
            subject.cells[100],
            subject.cells[101],
            subject.cells[116],
            subject.cells[117],
        ]

        let creatureA = Creature(cell: subject.cells[84], configuration: CreatureConfiguration.NAC01)
        let creatureB = Creature(cell: subject.cells[100], configuration: CreatureConfiguration.NAC01)
        let creatureC = Creature(cell: subject.cells[117], configuration: CreatureConfiguration.NAC01)

        subject.creatures.insert(creatureA)
        subject.creatures.insert(creatureB)
        subject.creatures.insert(creatureC)

        let result = subject.searchEmptyCellsFrom(searchCells)
        let expected = [
            subject.cells[85],
            subject.cells[99],
            subject.cells[101],
            subject.cells[116],
        ]

        XCTAssertEqual(result, expected)
    }
}
