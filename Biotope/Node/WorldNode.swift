import SpriteKit
import RxSwift
import SwiftGraphics

class WorldNode: SKNode {
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

    deinit {
        compositeDisposable.dispose()
    }

    func setUp() {
        setUpLayers()
        if debugMode {
            setUpCellInfoLayer()
        }
        setUpMapLayer()
        setUpCreatureLayer()

        compositeDisposable.addDisposable(
            world.creatureEmerged.subscribeNext { creature in
                self.enterNewCreature(creature)
            }
        )
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

        for (index, node) in layers.enumerate() {
            node.zPosition = CGFloat(index + 10000)
            addChild(node)
        }
    }

    func setUpCellInfoLayer() {
        let radius: CGFloat = 40 * 0.6
        let radian = 2 * M_PI / 6.0

        for (_, cell) in world.cells {
            let indexNode = SKLabelNode(fontNamed: "Arial")
            indexNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map)
            indexNode.text = "\(cell.index)"
            indexNode.fontSize = 16
            indexNode.verticalAlignmentMode = .Center
            indexNode.fontColor = .flatBlueColor()
            cellInfoLayer.addChild(indexNode)

            for direction in Cell.Direction.values {
                let r = radian * Double(direction.rawValue)
                let position = CGPointMake(radius * CGFloat(cos(r)), radius * CGFloat(sin(r)))

                if let destinationCell = cell[direction] {
                    let directionNode = SKLabelNode(fontNamed: "Arial")
                    directionNode.text = "\(destinationCell.index)"
                    directionNode.fontSize = 12
                    directionNode.verticalAlignmentMode = .Center
                    directionNode.fontColor = .flatGreenColor()
                    directionNode.position = indexNode.position + position
                    cellInfoLayer.addChild(directionNode)
                }
            }

            let nutritionNode = SKLabelNode(fontNamed: "Arial")
            nutritionNode.position = MapNode.tilePosition(index: cell.index, forMap: world.map) - CGPointMake(0, 18)
            nutritionNode.text = "N:\(cell.nutrition)"
            nutritionNode.fontSize = 16
            nutritionNode.verticalAlignmentMode = .Center
            nutritionNode.fontColor = .flatBlueColor()
            cellInfoLayer.addChild(nutritionNode)

            compositeDisposable.addDisposable(
                cell.nutritionChanged.subscribeNext { nutrition in
                    nutritionNode.text = "N:\(nutrition)"
                }
            )
        }
    }

    func setUpMapLayer() {
        for (_, tile) in mapLayer.tiles {
            tile.color = UIColor.flatOrangeColor()
        }

        let tileColorStepMax = 32
        for (_, cell) in world.cells {
            if let tile = mapLayer.tiles[cell.index] {
                tile.colorBlendFactor = CGFloat(cell.nutrition) / CGFloat(tileColorStepMax)
            }

            compositeDisposable.addDisposable(
                cell.nutritionChanged.subscribeNext { nutrition in
                    if let tile = self.mapLayer.tiles[cell.index] {
                        tile.colorBlendFactor = CGFloat(nutrition) / CGFloat(tileColorStepMax)
                    }
                }
            )
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
        creatureLayer.addChild(creatureNode)

        creatureNode.runAnimation(.Born, completion: {
            creature.isBorn = true
        })
    }

    func tileAtPoint(point: CGPoint) -> SKSpriteNode? {
        // note: tile node is overlapped on border of theirs
        return mapLayer.nodesAtPoint(point).filter { $0 is SKSpriteNode }.first as? SKSpriteNode
    }
}
