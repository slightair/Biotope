import UIKit
import XCTest

class BiotopeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformancePathFinder() {
        let world = World(named: "debug")
        let cellA = world.cells[100]
        let cellB = world.cells[200]

        let pathFinder = PathFinder(source: cellA, destination: cellB)
        let result = pathFinder.calculate()
        XCTAssertEqual(result!.map { $0.index }, [100, 117, 133, 150, 166, 183, 184, 200])

        self.measureBlock() {
            let pathFinder = PathFinder(source: cellA, destination: cellB)
            pathFinder.calculate()
        }
    }
}
