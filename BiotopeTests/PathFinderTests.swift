import Foundation
import XCTest

class PathFinderTests: XCTestCase {

    func testPerformancePathFinder() {
        let world = World(named: "test")
        let cellA = world.cells[100]!
        let cellB = world.cells[200]!

        let pathFinder = PathFinder(source: cellA, destination: cellB)
        let result = pathFinder.calculate()
        XCTAssertEqual(result!.map { $0.index }, [100, 117, 133, 150, 166, 183, 184, 200])

        self.measureBlock() {
            let pathFinder = PathFinder(source: cellA, destination: cellB)
            pathFinder.calculate()
        }
    }
}
