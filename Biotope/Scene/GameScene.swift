import SpriteKit
import SwiftGraphics

class GameScene: SKScene {
    var world: World!
    var worldNode: WorldNode!
    var creatureCountNode: CreatureCountNode!

    override func didMoveToView(view: SKView) {
        world = World(named: "debug")
        worldNode = WorldNode(world)
        addChild(worldNode)

        creatureCountNode = CreatureCountNode(world)
        creatureCountNode.zPosition = 20000
        creatureCountNode.position = CGPointMake(-CGRectGetWidth(self.frame) / 2 + CreatureCountNode.Size.width / 2,
                                                 -CGRectGetHeight(self.frame) / 2 + CreatureCountNode.Size.height * 3.5)
        addChild(creatureCountNode)

        world.start()
    }
    
    override func update(currentTime: CFTimeInterval) {
        GameScenePaceMaker.defaultPaceMaker.knock(currentTime)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)

        worldNode.position += location - previousLocation
    }
}
