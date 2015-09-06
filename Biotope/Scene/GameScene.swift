import SpriteKit
import SwiftGraphics

class GameScene: SKScene {
    var world: World!
    var worldNode: WorldNode!

    override func didMoveToView(view: SKView) {
        world = World(named: "debug")
        worldNode = WorldNode(world)
        addChild(worldNode)

        world.start()
    }
    
    override func update(currentTime: CFTimeInterval) {
        GameScenePaceMaker.defaultPaceMaker.knock(currentTime)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)

        worldNode.position += location - previousLocation
    }

    // debug
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(worldNode)

        if let tile = worldNode.tileAtPoint(location) {
            tile.colorBlendFactor = 0.5
            tile.color = UIColor.blueColor()
        }
    }
}
