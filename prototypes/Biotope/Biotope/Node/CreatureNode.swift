import SpriteKit
import RxSwift

class CreatureNode : SKSpriteNode {
    let creature : Creature

    required init(creature: Creature) {
        self.creature = creature

        let texture = SKTexture(imageNamed: creature.imageName())
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())

        creature.positionChanged
            >- subscribeNext { position in
                self.removeAllActions()

                let distanceX = self.position.x - CGFloat(position.x)
                let distanceY = self.position.y - CGFloat(position.y)
                let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
                let duration = NSTimeInterval(distance) / 30

                let action = SKAction.moveTo(position.CGPointValue, duration: duration)
                let completion = SKAction.runBlock {
                    creature.isMoving = false
                }
                self.runAction(SKAction.sequence([action, completion]))
            }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

