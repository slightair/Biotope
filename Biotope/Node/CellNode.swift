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

        var shapePath = CGPathCreateMutable()
        shapePath.move(CGPointMake(size * CGFloat(cos(M_PI_2)), size * CGFloat(sin(M_PI_2))))
        for i in 0..<6 {
            let r = 2 * M_PI / 6.0 * Double(i + 1) + M_PI_2
            let point = CGPointMake(size * CGFloat(cos(r)), size * CGFloat(sin(r)))
            shapePath.addLine(point)
        }
        self.path = shapePath
        self.lineWidth = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
