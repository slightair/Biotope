import SpriteKit
import SwiftGraphics
import ChameleonFramework

class CellNode: SKNode {
    let cell: Cell
    let size: CGFloat

    init(_ cell: Cell, size: CGFloat) {
        self.cell = cell
        self.size = size
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
