import SpriteKit
import SwiftGraphics

class GameScene: SKScene {
    var world: World!
    var worldNode: WorldNode!

    override func didMoveToView(view: SKView) {
        world = World(named: "debug")
        worldNode = WorldNode(world)
        let scale: CGFloat = 0.7
        worldNode.xScale = scale
        worldNode.yScale = scale
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
}
