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
            path.addHex(MapNode.tilePosition(cell: cell), size: hexSize)
        }

        self.path = path
        self.strokeColor = UIColor.flatGrayColor()
        self.fillColor = UIColor.whiteColor()
    }
}
