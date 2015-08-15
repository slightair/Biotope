import SpriteKit
import RxSwift
import SwiftGraphics

class WorldNode: SKNode {
    let world: World
    let mapLayer: MapNode
    let creatureLayer = SKNode()
    let compositeDisposable = CompositeDisposable()

    // for debug
    let hexSize: CGFloat = 60
    let hexLayer: HexNode
    let cellIndexLayer = SKNode()
    let creatureRouteLayer = SKNode()
    var creatureRouteNodeList: [Int: SKNode] = [:]

    init(_ world: World) {
        self.world = world
        self.mapLayer = MapNode(map: world.map)
        self.hexLayer = HexNode(world: world, hexSize: hexSize)

        super.init()

        let layers = [
//            mapLayer,
            hexLayer,
            creatureRouteLayer,
            cellIndexLayer,
            creatureLayer,
        ]

        for (index, node) in enumerate(layers) {
            node.zPosition = CGFloat(index + 10000)
            addChild(node)
        }

        setUpCellIndexLayer()
        setUpCreatureLayer()
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
                        self.updateCreatureRouteNode(creature: creature, pathFinder: pathFinder!)
                    }
                }
                >- compositeDisposable.addDisposable
        }
    }

    func updateCreatureRouteNode(#creature: Creature, pathFinder: PathFinder) {
        if let prevRouteNode = creatureRouteNodeList[creature.id] {
            prevRouteNode.removeFromParent()
        }

        if let route = pathFinder.result {
            let routeNode = SKNode()

            for (index, cell) in enumerate(route) {
                let cellNode = CellNode(cell, size: hexSize)
                cellNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map)

                cellNode.strokeColor = UIColor.darkColorWithName(creature.configuration.debugInfo.colorName)

                let baseFillColor = UIColor.colorWithName(creature.configuration.debugInfo.colorName)
                if index == route.count - 1 {
                    cellNode.fillColor = baseFillColor.colorWithAlphaComponent(0.3)
                } else {
                    cellNode.fillColor = baseFillColor.colorWithAlphaComponent(0.1)
                }

                routeNode.addChild(cellNode)
            }

            creatureRouteNodeList[creature.id] = routeNode
            creatureRouteLayer.addChild(routeNode)
        }
    }
}
