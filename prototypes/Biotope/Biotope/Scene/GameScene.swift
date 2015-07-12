import SpriteKit

class GameScene: SKScene {
    var world: World!
    var worldNode: WorldNode!

    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true

        setUpWorld()
        world.run()
    }

    override func update(currentTime: CFTimeInterval) {
        GameScenePaceMaker.defaultPaceMaker.knock(currentTime)
    }

    func setUpWorld() {
        world = World()

        let canvasSize = CGSizeMake(CGFloat(world.width), CGFloat(world.height))
        worldNode = WorldNode(rectOfSize: canvasSize)
        worldNode.setUp(world)
        self.addChild(worldNode!)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)

        worldNode!.position.x += location.x - previousLocation.x
        worldNode!.position.y += location.y - previousLocation.y
    }
}
