import SpriteKit
import RxSwift
import ChameleonFramework
import SwiftGraphics

class WorldNode: SKShapeNode {
    let lineInterval: CGFloat = 64
    let roomLayer = SKNode()
    let bridgeLayer = SKNode()
    let creatureLayer = SKNode()
    let compositeDisposable = CompositeDisposable()

    deinit {
        compositeDisposable.dispose()
    }

    func setUp(world: World) {
        setUpLayers()
        setUpLines()

        setUpRooms(world)
        setUpBridges(world)
        setUpCreatures(world)

        world.creatureEmerged
            >- subscribeNext { creature in
                self.enterNewCreature(creature)
            }
            >- compositeDisposable.addDisposable
    }

    func setUpLayers() {
        addChild(self.roomLayer)
        addChild(self.bridgeLayer)
        addChild(self.creatureLayer)
    }

    func setUpLines() {
        let path = CGPathCreateMutable()

        CGPathAddRect(path, nil, frame)

        let numHorizontalLines = Int(frame.height / lineInterval)
        let numVerticalLines = Int(frame.width / lineInterval)

        for x in -((numVerticalLines / 2) - 1)..<(numVerticalLines / 2) {
            let xPos = lineInterval * CGFloat(x)
            path.move(CGPoint(xPos, CGRectGetMinY(frame)))
            path.addLine(CGPoint(xPos, CGRectGetMaxY(frame)))
        }

        for y in -((numHorizontalLines / 2) - 1)..<(numHorizontalLines / 2) {
            let yPos = lineInterval * CGFloat(y)
            path.move(CGPoint(CGRectGetMinX(frame), yPos))
            path.addLine(CGPoint(CGRectGetMaxX(frame), yPos))
        }

        self.path = path
        self.strokeColor = UIColor.flatGrayColor()
        self.fillColor = UIColor.whiteColor()
    }

    func setUpRooms(world: World) {
        for room in world.rooms {
            let roomNode = RoomNode(room: room)
            roomNode.position = room.position.CGPointValue

            roomLayer.addChild(roomNode)
        }
    }

    func setUpBridges(world: World) {
        for bridge in world.bridges {
            let bridgeNode = BridgeNode(bridge: bridge)

            bridgeLayer.addChild(bridgeNode)
        }
    }

    func setUpCreatures(world: World) {
        for creature in world.creatures {
            let creatureNode = CreatureNode(creature: creature)
            creatureNode.position = creature.position.CGPointValue
            creatureLayer.addChild(creatureNode)

            // for Debug
            if let directionNode = creatureNode.directionNode {
                creatureLayer.addChild(directionNode)
            }
        }
    }

    func enterNewCreature(creature: Creature) {
        let creatureNode = CreatureNode(creature: creature)
        creatureNode.position = creature.position.CGPointValue
        creatureNode.setScale(0.1)
        creatureLayer.addChild(creatureNode)

        // for Debug
        if let directionNode = creatureNode.directionNode {
            creatureLayer.addChild(directionNode)
        }

        let popAction = SKAction.scaleTo(1.0, duration: 1.0)
        creatureNode.runAction(popAction, completion: {
            creature.isBorn = true
        })
    }
}