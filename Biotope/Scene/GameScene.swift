import SpriteKit
import SwiftGraphics

class GameScene: SKScene {
    let canvasNode = CanvasNode.defaultNode()

    override func didMoveToView(view: SKView) {
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
