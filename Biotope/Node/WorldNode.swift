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
    let debugMode = false
    let cellInfoLayer = SKNode()

    init(_ world: World) {
        self.world = world
        self.mapLayer = MapNode(map: world.map)

        super.init()

        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        setUpLayers()
        if debugMode {
            setUpCellInfoLayer()
        }
        setUpMapLayer()
        setUpCreatureLayer()

        world.creatureEmerged
            >- subscribeNext { creature in
                self.enterNewCreature(creature)
            }
            >- compositeDisposable.addDisposable
    }

    func setUpLayers() {
        var layers = [
            mapLayer,
            cellInfoLayer,
            creatureLayer,
        ]

        if !debugMode {
            layers.removeAtIndex(1) // cellInfoLayer
        }

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

    func setUpMapLayer() {
        for (index, tile) in mapLayer.tiles {
            tile.color = UIColor.flatOrangeColor()
        }

        let tileColorStepMax = 32
        for cell in world.cells {
            if let tile = self.mapLayer.tiles[cell.index] {
                tile.colorBlendFactor = CGFloat(cell.nutrition) / CGFloat(tileColorStepMax)
            }

            cell.nutritionChanged
                >- subscribeNext { nutrition in
                    if let tile = self.mapLayer.tiles[cell.index] {
                        tile.colorBlendFactor = CGFloat(nutrition) / CGFloat(tileColorStepMax)
                    }
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
