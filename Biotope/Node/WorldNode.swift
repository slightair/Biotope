import SpriteKit
import RxSwift
import SwiftGraphics

class WorldNode: SKNode {
    static let hexSize: CGFloat = 60

    let world: World
    let mapLayer: MapNode
    let creatureLayer = SKNode()
    let compositeDisposable = CompositeDisposable()

    // for debug
    let hexLayer: HexNode
    let cellInfoLayer = SKNode()

    init(_ world: World) {
        self.world = world
        self.mapLayer = MapNode(map: world.map)
        self.hexLayer = HexNode(world: world, hexSize: WorldNode.hexSize)

        super.init()

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        setUpLayers()
        setUpCellInfoLayer()
        setUpCreatureLayer()

        world.creatureEmerged
            >- subscribeNext { creature in
                self.enterNewCreature(creature)
            }
            >- compositeDisposable.addDisposable
    }

    func setUpLayers() {
        let layers = [
//            mapLayer,
            hexLayer,
            cellInfoLayer,
            creatureLayer,
        ]

        for (index, node) in enumerate(layers) {
            node.zPosition = CGFloat(index + 10000)
            addChild(node)
        }
    }

    func setUpCellInfoLayer() {
        let mapOffset = MapNode.mapOffset(world.map)
        for cell in world.cells {
            let indexNode = SKLabelNode(fontNamed: "Arial")
            indexNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map)
            indexNode.text = "\(cell.index)"
            indexNode.fontSize = 16
            indexNode.verticalAlignmentMode = .Center
            indexNode.fontColor = .flatBlueColor()
            cellInfoLayer.addChild(indexNode)

            let nutritionNode = SKLabelNode(fontNamed: "Arial")
            nutritionNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map) - CGPointMake(0, 18)
            nutritionNode.text = "N:\(cell.nutrition)"
            nutritionNode.fontSize = 16
            nutritionNode.verticalAlignmentMode = .Center
            nutritionNode.fontColor = .flatBlueColor()
            cellInfoLayer.addChild(nutritionNode)

            cell.nutritionChanged
                >- subscribeNext { nutrition in
                    nutritionNode.text = "N:\(nutrition)"
                }
                >- compositeDisposable.addDisposable
        }
    }

    func setUpCreatureLayer() {
        for creature in world.creatures {
            let creatureNode = CreatureNode(creature: creature)
            creatureLayer.addChild(creatureNode)
        }
    }

    func enterNewCreature(creature: Creature) {
        let creatureNode = CreatureNode(creature: creature)
        creatureNode.setScale(0.1)
        creatureLayer.addChild(creatureNode)

        let popAction = SKAction.scaleTo(1.0, duration: 1.0)
        creatureNode.runAction(popAction, completion: {
            creature.isBorn = true
        })
    }
}
