import SpriteKit
import SwiftGraphics

class HexNode: SKShapeNode {
    let world: World
    let hexSize: CGFloat

    required init(world: World, hexSize: CGFloat) {
        self.world = world
        self.hexSize = hexSize
        super.init()

        setUpPath()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpPath() {
        let path = CGPathCreateMutable()

        for cell in world.cells {
            let position = MapNode.tilePosition(cell: cell)

            path.move(CGPointMake(hexSize * CGFloat(cos(M_PI_2)), hexSize * CGFloat(sin(M_PI_2))) + position)
            for i in 0..<6 {
                let r = 2 * M_PI / 6.0 * Double(i + 1) + M_PI_2
                let point = CGPointMake(hexSize * CGFloat(cos(r)), hexSize * CGFloat(sin(r))) + position
                path.addLine(point)
            }
        }

        self.path = path
        self.strokeColor = UIColor.flatGrayColor()
        self.fillColor = UIColor.whiteColor()
    }
}
