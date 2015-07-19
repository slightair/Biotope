import SpriteKit
import RxSwift
import SwiftGraphics
import ChameleonFramework

class CreatureNode: SKNode {
    let creature: Creature
    var spriteNode: SKSpriteNode?

    // for Debug
    var sightNode: SKShapeNode?
    var positionNode: SKLabelNode?
    var directionNode: SKShapeNode?

    required init(creature: Creature) {
        self.creature = creature
        super.init()

        setUpNodes()

        creature.targetPositionChanged
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

        GameScenePaceMaker.defaultPaceMaker.paceSubject
            >- subscribeNext { currentTime in
                self.creature.position = Position(point: self.position)
                self.positionNode?.text = "\(creature.position)"

                let path = CGPathCreateMutable()
                path.move(creature.position.CGPointValue)
                path.addLine(creature.targetPosition.CGPointValue)
                self.directionNode?.path = path
            }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpNodes() {
        if creature.configuration.sight > 0 {
            sightNode = SKShapeNode(circleOfRadius: CGFloat(creature.configuration.sight))
            sightNode?.fillColor = UIColor.flatLimeColor().colorWithAlphaComponent(0.3)
            sightNode?.lineWidth = 0
            addChild(sightNode!)
        }

        spriteNode = SKSpriteNode(imageNamed: creature.imageName())
        addChild(spriteNode!)

        positionNode = SKLabelNode(fontNamed: "Arial")
        positionNode?.fontSize = 10
        positionNode?.fontColor = .flatTealColor()
        positionNode?.position = CGPointMake(0, -24)
        addChild(positionNode!)

        if creature.configuration.speed > 0 {
            directionNode = SKShapeNode()
            directionNode?.strokeColor = UIColor.flatOrangeColor().colorWithAlphaComponent(0.75)
            directionNode?.lineWidth = 3.0
        }
    }
}

