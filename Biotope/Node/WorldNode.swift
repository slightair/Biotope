import SpriteKit
import SwiftGraphics

class WorldNode: SKNode {

    let world: World
    let mapLayer: MapNode
    let canvasNode = CanvasNode.defaultNode()
    let cellLayer = SKNode()
    let creatureLayer = SKNode()

    init(_ world: World) {
        self.world = world
        self.mapLayer = MapNode(map: world.map)

        super.init()

        canvasNode.addChild(mapLayer)
        canvasNode.addChild(cellLayer)
        canvasNode.addChild(creatureLayer)

        for (index, node) in enumerate([mapLayer, cellLayer, creatureLayer]) {
            node.zPosition = CGFloat(index + 10000)
        }

        setUpCellLayer()
        setUpCreatureLayer()

        addChild(canvasNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpCellLayer() {
        let mapOffset = MapNode.mapOffset(world.map)
        for cell in world.cells {
            let cellNode = CellNode(cell, size: CGFloat(60))
            cellNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map)
            cellLayer.addChild(cellNode)
        }
    }

    func setUpCreatureLayer() {
        for creature in world.creatures {
            let creatureNode = CreatureNode(creature: creature)
            creatureLayer.addChild(creatureNode)
        }
    }
}
