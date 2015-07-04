import SpriteKit

class WorldNode: SKNode {
    var canvasNode : WorldCanvasNode!

    func setUp(size: CGSize) {
        userInteractionEnabled = true

        canvasNode = WorldCanvasNode(rectOfSize: size)
        canvasNode.setUpLines()
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
