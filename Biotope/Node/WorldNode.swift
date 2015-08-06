import SpriteKit
import SwiftGraphics

class WorldNode: SKNode {
    let world: World
    let canvasNode: CanvasNode
    let mapNode: MapNode
    let cellLayer: SKNode

    init(_ world: World) {
        self.world = world
        self.canvasNode = CanvasNode.defaultNode()
        self.mapNode = MapNode(map: world.map)
        self.cellLayer = SKNode()

        super.init()

        canvasNode.addChild(mapNode)

        let mapOffset = MapNode.mapOffset(world.map)
        for cell in world.cells {
            let cellNode = CellNode(cell, size: CGFloat(60))
            cellNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map) + mapOffset
            cellLayer.addChild(cellNode)
        }

        cellLayer.zPosition = 10000
        canvasNode.addChild(cellLayer)

        addChild(canvasNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
