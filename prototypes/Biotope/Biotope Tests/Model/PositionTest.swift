import UIKit
import XCTest

class PositionTest: XCTestCase {

    func testCGPointValue() {
        let x: Double = 100
        let y: Double = 200

        let expected = CGPointMake(CGFloat(x), CGFloat(y))
        let position = Position(x: x, y: y)

        XCTAssertEqual(expected, position.CGPointValue)
    }
}
