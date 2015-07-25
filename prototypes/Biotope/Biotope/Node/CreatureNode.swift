import SpriteKit
import RxSwift
import SwiftGraphics
import ChameleonFramework

class CreatureNode: SKNode {
    let creature: Creature
    var spriteNode: SKSpriteNode?
    let compositeDisposable = CompositeDisposable()

    // for Debug
    var sightNode: SKShapeNode?
    var hpNode: SKLabelNode?
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
            >- compositeDisposable.addDisposable

        creature.lifeSubject
            >- subscribeNext { hp in
                hpNode?.text = "HP:\(hp)"
            }
            >- compositeDisposable.addDisposable

        creature.lifeSubject
            >- subscribeCompleted {
                self.compositeDisposable.dispose()
                self.runDeadAnimation()
            }
            >- compositeDisposable.addDisposable

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                creature.position = Position(point: self.position)
                self.collisionCheck()
                self.updateDebugInfo()
            }
            >- compositeDisposable.addDisposable
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

        hpNode = SKLabelNode(fontNamed: "Arial")
        hpNode?.fontSize = 10
        hpNode?.fontColor = .flatTealColor()
        hpNode?.position = CGPointMake(0, -24)
        hpNode?.text = "HP:\(creature.hp)"
        addChild(hpNode!)

        if creature.configuration.speed > 0 {
            directionNode = SKShapeNode()
            directionNode?.strokeColor = UIColor.flatOrangeColor().colorWithAlphaComponent(0.75)
            directionNode?.lineWidth = 3.0
        }
    }

    func runDeadAnimation() {
        directionNode?.removeFromParent()
        removeAllActions()

        self.spriteNode?.color = UIColor.blackColor()
        self.spriteNode?.colorBlendFactor = 0.5

        let reduceAction = SKAction.scaleTo(0.0, duration: 1.0)
        runAction(reduceAction, completion: {
            self.removeFromParent()
            self.creature.decompose()
        })
    }

    func collisionCheck() {
        if creature is NonActiveCreature {
            return
        }

        let creatureNodes = parent?.children.filter { $0 is CreatureNode } as? [CreatureNode]
        if creatureNodes == nil {
            return
        }

        let collisionCreatures = creatureNodes!.filter { $0 != self }
                                               .filter { self.spriteNode!.intersectsNode($0.spriteNode!) }
                                               .map { $0.creature }

        for creature in collisionCreatures {
            (self.creature as! ActiveCreature).collisionTo(creature)
        }
    }

    func updateDebugInfo() {
        let path = CGPathCreateMutable()
        path.move(creature.position.CGPointValue)
        path.addLine(creature.targetPosition.CGPointValue)
        directionNode?.path = path
    }
}
