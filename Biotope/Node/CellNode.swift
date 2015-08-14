import SpriteKit
import SwiftGraphics
import ChameleonFramework

class CellNode: SKShapeNode {
    enum Mode {
        case Normal, Route, Target
    }

    let cell: Cell
    let size: CGFloat
    let shapePath: CGPath

    var mode: Mode {
        didSet {
            switch mode {
            case .Normal:
                self.path = nil
                self.fillColor = UIColor.whiteColor()
            case .Route:
                self.path = shapePath
                self.fillColor = UIColor.flatOrangeColor().colorWithAlphaComponent(0.1)
            case .Target:
                self.path = shapePath
                self.fillColor = UIColor.flatOrangeColor().colorWithAlphaComponent(0.3)
            }
        }
    }

    init(_ cell: Cell, size: CGFloat) {
        self.cell = cell
        self.size = size
        self.mode = .Normal

        var shapePath = CGPathCreateMutable()
        shapePath.move(CGPointMake(size * CGFloat(cos(M_PI_2)), size * CGFloat(sin(M_PI_2))))
        for i in 0..<6 {
            let r = 2 * M_PI / 6.0 * Double(i + 1) + M_PI_2
            let point = CGPointMake(size * CGFloat(cos(r)), size * CGFloat(sin(r)))
            shapePath.addLine(point)
        }
        self.shapePath = shapePath

        super.init()

        setUpLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpLayers() {
        let indexNode = SKLabelNode(fontNamed: "Arial")
        indexNode.text = "\(self.cell.index)"
        indexNode.fontSize = 16
        indexNode.verticalAlignmentMode = .Center
        indexNode.fontColor = .flatBlueColor()
        addChild(indexNode)

//        let radius = size * 0.6
//        let radian = 2 * M_PI / 6.0
//
//        for direction in Cell.Direction.values {
//            let r = radian * Double(direction.rawValue)
//            let position = CGPointMake(radius * CGFloat(cos(r)), radius * CGFloat(sin(r)))
//
//            if let destinationCell = cell[direction] {
//                let indexNode = SKLabelNode(fontNamed: "Arial")
//                indexNode.text = "\(destinationCell.index)"
//                indexNode.fontSize = 12
//                indexNode.verticalAlignmentMode = .Center
//                indexNode.fontColor = .flatBlueColor()
//                indexNode.position = position
//                addChild(indexNode)
//            }
//        }
    }
}
