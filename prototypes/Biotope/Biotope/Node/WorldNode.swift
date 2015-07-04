import SpriteKit

class WorldNode: SKNode {
    var canvasNode : WorldCanvasNode!
    var world : World!

    func setUp(world: World) {
        userInteractionEnabled = true

        self.world = world

        let canvasSize = CGSizeMake(CGFloat(world.width), CGFloat(world.height))
        canvasNode = WorldCanvasNode(rectOfSize: canvasSize)
        canvasNode.setUpLines()
        canvasNode.position = CGPointMake(-canvasSize.width / 2, -canvasSize.height / 2)

        for room in world.rooms {
            let roomNode = RoomNode()
            roomNode.room = room
            roomNode.position = CGPointMake(canvasSize.width / 2 + CGFloat(room.x) - CGFloat(room.size) / 2,
                                            canvasSize.height / 2 + CGFloat(room.y) - CGFloat(room.size) / 2)

            canvasNode.addChild(roomNode);
        }

        addChild(canvasNode)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)

        canvasNode.position.x += location.x - previousLocation.x
        canvasNode.position.y += location.y - previousLocation.y
    }
}
