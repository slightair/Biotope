import SpriteKit
import SwiftGraphics
import ChameleonFramework

class CellNode: SKShapeNode {
    enum Mode {
        case Normal, Route, Target
    }

    let cell: Cell
    let size: CGFloat

    var mode: Mode = .Normal {
        didSet {
            switch mode {
            case .Normal:
                self.fillColor = UIColor.clearColor()
            case .Route:
                self.strokeColor = UIColor.flatGreenColorDark()
                self.fillColor = UIColor.flatGreenColor().colorWithAlphaComponent(0.1)
            case .Target:
                self.strokeColor = UIColor.flatGreenColorDark()
                self.fillColor = UIColor.flatGreenColor().colorWithAlphaComponent(0.3)
            }
        }
    }

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
