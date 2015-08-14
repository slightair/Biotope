import SpriteKit
import RxSwift
import SwiftGraphics

class WorldNode: SKNode {

    let world: World
    let mapLayer: MapNode
    let canvasNode = CanvasNode.defaultNode()
    let cellLayer = SKNode()
    let creatureLayer = SKNode()
    let compositeDisposable = CompositeDisposable()

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
            cellNode.name = "Cell-\(cell.index)"
            cellLayer.addChild(cellNode)
        }
    }

    func setUpCreatureLayer() {
        for creature in world.creatures {
            let creatureNode = CreatureNode(creature: creature)
            creatureLayer.addChild(creatureNode)

            creature.targetPathFinderChanged
                >- subscribeNext { pathFinder in
                    if pathFinder != nil {
                        self.updateCellNodesMode(pathFinder!)
                    }
                }
                >- compositeDisposable.addDisposable
        }
    }

    func updateCellNodesMode(pathFinder: PathFinder) {
        let cellNodes = cellLayer.children.filter { $0 is CellNode }.map { $0 as! CellNode }
        for cellNode in cellNodes {
            if cellNode.mode != .Normal {
                cellNode.mode = .Normal
            }
        }

        if let route = pathFinder.result {
            for (index, cell) in enumerate(route) {
                if let targetCellNode = cellNodeAtIndex(cell.index) {
                    targetCellNode.mode = index == route.count - 1 ? .Target : .Route
                }
            }
        }
    }

    func cellNodeAtIndex(index: Int) -> CellNode? {
        return cellLayer.childNodeWithName("Cell-\(index)") as? CellNode
    }
}
