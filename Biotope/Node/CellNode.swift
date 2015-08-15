import SpriteKit
import SwiftGraphics
import ChameleonFramework

class CellNode: SKShapeNode {
    let cell: Cell
    let size: CGFloat

    init(_ cell: Cell, size: CGFloat) {
        self.cell = cell
        self.size = size
        super.init()

        self.path = CGPathCreateMutable().addHex(CGPointZero, size: size)
        self.lineWidth = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
