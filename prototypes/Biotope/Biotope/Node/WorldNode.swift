import SpriteKit
import CoreGraphics
import ChameleonFramework

class WorldNode: SKShapeNode {
    let lineInterval: CGFloat = 64
    let roomLayer = SKNode()
    let bridgeLayer = SKNode()
    let creatureLayer = SKNode()

    func setUp(world: World) {
        setUpLayers()
        setUpLines()

        setUpRooms(world)
        setUpBridges(world)
        setUpCreatures(world)
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
            CGPathMoveToPoint(path, nil, lineInterval * CGFloat(x), CGRectGetMinY(frame))
            CGPathAddLineToPoint(path, nil, lineInterval * CGFloat(x), CGRectGetMaxY(frame))
        }

        for y in -((numHorizontalLines / 2) - 1)..<(numHorizontalLines / 2) {
            CGPathMoveToPoint(path, nil, CGRectGetMinX(frame), lineInterval * CGFloat(y))
            CGPathAddLineToPoint(path, nil, CGRectGetMaxX(frame), lineInterval * CGFloat(y))
        }

        self.path = path
        self.strokeColor = UIColor.flatGrayColor()
        self.fillColor = UIColor.whiteColor()
    }

    func setUpRooms(world: World) {
        for room in world.rooms {
            let roomNode = RoomNode(room: room)
            roomNode.position = CGPointMake(CGFloat(room.position.x) - CGFloat(room.size) / 2,
                                            CGFloat(room.position.y) - CGFloat(room.size) / 2)

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
        }
    }
}