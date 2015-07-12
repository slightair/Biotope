import SpriteKit

class CreatureNode : SKSpriteNode {
    let creature : Creature

    required init(creature: Creature) {
        self.creature = creature

        let texture = SKTexture(imageNamed: creature.imageName())
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

