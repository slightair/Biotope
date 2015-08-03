import SpriteKit
import SwiftGraphics

class GameScene: SKScene {
    let canvasNode = CanvasNode.defaultNode()
    var mapNode: MapNode!

    override func didMoveToView(view: SKView) {
        mapNode = MapNode(fileNamed: "debug")
        canvasNode.addChild(mapNode)

        addChild(canvasNode)
    }
    
    override func update(currentTime: CFTimeInterval) {

    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)

        canvasNode.position += location - previousLocation
    }
}
