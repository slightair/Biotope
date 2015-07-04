import SpriteKit

class CreatureNode : SKSpriteNode {
    var creature : Creature! {
        didSet {
            updateTexture()
        }
    }

    func updateTexture() {
        let texture = SKTexture(imageNamed: creature.imageName())
        self.texture = texture
        self.size = texture.size()
    }
}

