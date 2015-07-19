import SpriteKit
import RxSwift
import SwiftGraphics

class CreatureNode: SKNode {
    let creature: Creature
    var sightNode: SKShapeNode?
    var spriteNode: SKSpriteNode?

    required init(creature: Creature) {
        self.creature = creature
        super.init()

        setUpNodes()

        creature.positionChanged
            >- subscribeNext { position in
                self.removeAllActions()

                let distance = self.position.distanceTo(position.CGPointValue)
                let speed = creature.configuration.speed > 0 ? creature.configuration.speed : 1
                let duration = NSTimeInterval(distance) / 10 / speed

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

    func setUpNodes() {
        sightNode = SKShapeNode(circleOfRadius: CGFloat(creature.configuration.sight))
        addChild(sightNode!)

        spriteNode = SKSpriteNode(imageNamed: creature.imageName())
        addChild(spriteNode!)
    }
}

