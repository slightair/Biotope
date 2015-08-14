import SpriteKit
import RxSwift
import SwiftGraphics

class WorldNode: SKNode {

    let world: World
    let mapLayer: MapNode
    let canvasNode = CanvasNode.defaultNode()
    let creatureLayer = SKNode()
    let compositeDisposable = CompositeDisposable()

    // for debug
    let cellIndexLayer = SKNode()
    let creatureRouteLayer = SKNode()
    var creatureRouteNodeList: [Int: SKNode] = [:]

    init(_ world: World) {
        self.world = world
        self.mapLayer = MapNode(map: world.map)

        super.init()

        let layers = [
            mapLayer,
            creatureRouteLayer,
            cellIndexLayer,
            creatureLayer,
        ]

        for (index, node) in enumerate(layers) {
            node.zPosition = CGFloat(index + 10000)
            canvasNode.addChild(node)
        }

        setUpCellIndexLayer()
        setUpCreatureLayer()

        addChild(canvasNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpCellIndexLayer() {
        let mapOffset = MapNode.mapOffset(world.map)
        for cell in world.cells {
            let indexNode = SKLabelNode(fontNamed: "Arial")
            indexNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map)
            indexNode.text = "\(cell.index)"
            indexNode.fontSize = 16
            indexNode.verticalAlignmentMode = .Center
            indexNode.fontColor = .flatBlueColor()
            cellIndexLayer.addChild(indexNode)
        }
    }

    func setUpCreatureLayer() {
        for creature in world.creatures {
            let creatureNode = CreatureNode(creature: creature)
            creatureLayer.addChild(creatureNode)

            creature.targetPathFinderChanged
                >- subscribeNext { pathFinder in
                    if pathFinder != nil {
                        self.updateCreatureRouteNode(creatureID: creature.id, pathFinder: pathFinder!)
                    }
                }
                >- compositeDisposable.addDisposable
        }
    }

    func updateCreatureRouteNode(#creatureID: Int, pathFinder: PathFinder) {
        if let prevRouteNode = creatureRouteNodeList[creatureID] {
            prevRouteNode.removeFromParent()
        }

        if let route = pathFinder.result {
            let routeNode = SKNode()

            for (index, cell) in enumerate(route) {
                let cellNode = CellNode(cell, size: CGFloat(60))
                cellNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map)
                cellNode.mode = index == route.count - 1 ? .Target : .Route

                routeNode.addChild(cellNode)
            }

            creatureRouteNodeList[creatureID] = routeNode
            creatureRouteLayer.addChild(routeNode)
        }
    }
}
