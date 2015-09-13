import Foundation
import XCTest

class WorldTests: XCTestCase {
    var subject: World!
    let creatureConfiguration = CreatureConfigurationStore.defaultStore[0]

    override func setUp() {
        super.setUp()

        subject = World(named: "test")
        subject.creatures.removeAll()
    }

    func testSearchEmptyCellsFrom() {
        //    84 -  85
        // 99 - 100 - 101
        //   116 - 117

        let searchCells = [
            subject.cells[84]!,
            subject.cells[85]!,
            subject.cells[99]!,
            subject.cells[100]!,
            subject.cells[101]!,
            subject.cells[116]!,
            subject.cells[117]!,
        ]

        let creatureA = Creature(cell: subject.cells[84]!, configuration: creatureConfiguration)
        let creatureB = Creature(cell: subject.cells[100]!, configuration: creatureConfiguration)
        let creatureC = Creature(cell: subject.cells[117]!, configuration: creatureConfiguration)

        subject.creatures.insert(creatureA)
        subject.creatures.insert(creatureB)
        subject.creatures.insert(creatureC)

        let result = subject.searchEmptyCellsFrom(searchCells)
        let expected = [
            subject.cells[85]!,
            subject.cells[99]!,
            subject.cells[101]!,
            subject.cells[116]!,
        ]

        XCTAssertEqual(result, expected)
    }
}
