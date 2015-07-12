import SpriteKit
import RxSwift

class CreatureNode : SKSpriteNode {
    let creature : Creature

    required init(creature: Creature) {
        self.creature = creature

        let texture = SKTexture(imageNamed: creature.imageName())
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())

        creature.positionChanged
            >- subscribeNext { x, y in
                let action = SKAction.moveTo(CGPointMake(CGFloat(x), CGFloat(y)), duration: 0.2)
                self.runAction(action)
            }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

