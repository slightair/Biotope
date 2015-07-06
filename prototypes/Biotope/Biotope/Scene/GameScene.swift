import SpriteKit

class GameScene: SKScene {
    let worldNode = WorldNode()

    override func didMoveToView(view: SKView) {
        setUpWorld()
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func setUpWorld() {
        let world = World()

        worldNode.setUp(world)
        self.addChild(worldNode)
    }
}
