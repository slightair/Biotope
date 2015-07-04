import SpriteKit

class GameScene: SKScene {
    let worldNode = WorldNode();

    override func didMoveToView(view: SKView) {
        setUpWorld()
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func setUpWorld() {
        worldNode.setUp(CGSizeMake(2048.0, 2048.0))
        self.addChild(worldNode);
    }
}
