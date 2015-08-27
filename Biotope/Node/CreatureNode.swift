import SpriteKit
import RxSwift
import ChameleonFramework
import SwiftGraphics

class CreatureNode: SKNode {
    let creature: Creature
    var spriteNode: SKSpriteNode!
    let compositeDisposable = CompositeDisposable()

    // for Debug
    let debugMode = false
    var hpNode: SKLabelNode!
    var nutritionNode: SKLabelNode!

    required init(creature: Creature) {
        self.creature = creature
        super.init()

        setUpNodes()
        changePosition(animated: false)
        changeDirection()

        creature.currentCellChanged
            >- subscribeNext { cell in
                self.removeAllActions()
                self.changePosition()
            }
            >- compositeDisposable.addDisposable

        creature.currentDirectionChanged
            >- subscribeNext { direction in
                self.changeDirection()
            }
            >- compositeDisposable.addDisposable

        creature.life
            >- subscribeCompleted {
                self.compositeDisposable.dispose()
                self.runDeadAnimation()
            }
            >- compositeDisposable.addDisposable

        creature.actionCompleted
            >- subscribeNext { result in
                self.runActionCompletedAnimation(result)
            }
            >- compositeDisposable.addDisposable

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.collisionCheck()
            }
            >- compositeDisposable.addDisposable

        if debugMode {
            creature.life
                >- subscribeNext { hp in
                    self.hpNode.text = "HP:\(hp)"
                }
                >- compositeDisposable.addDisposable

            creature.nutritionChanged
                >- subscribeNext { nutrition in
                    self.nutritionNode.text = "N:\(nutrition)"
                }
                >- compositeDisposable.addDisposable
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatureShapePath() -> CGPath {
        switch creature.configuration.trophicLevel {
        case .Nutrition:
            fallthrough
        case .Producer:
            return Circle(center: CGPointZero, radius: 24).cgpath
        case .Consumer1:
            fallthrough
        case .Consumer2:
            return CGPathCreateMutable().addArrow(size: 36)
        }
    }

    func creatureTextureAtlas() -> CreatureTextureAtlas {
        var textureName: String

        switch creature.configuration.trophicLevel {
        case .Nutrition:
            fallthrough
        case .Producer:
            textureName = "flower"
        case .Consumer1:
            textureName = "rabbit"
        case .Consumer2:
            textureName = "rabbit"
        }

        return TextureAtlasStore.defaultStore[textureName] as! CreatureTextureAtlas
    }

    func defaultAnimateAction() -> SKAction {
        let textures = creatureTextureAtlas().texturesForAnimation(.Wait)
        let animateAction = SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: CreatureTextureAtlas.AnimationDuration))
        return animateAction
    }

    func setUpNodes() {
        spriteNode = SKSpriteNode(texture: creatureTextureAtlas().defaultTexture())
        spriteNode.runAction(defaultAnimateAction())
        addChild(spriteNode)

        if debugMode {
            hpNode = SKLabelNode(fontNamed: "Arial")
            hpNode.fontSize = 12
            hpNode.fontColor = UIColor.flatWhiteColor()
            hpNode.verticalAlignmentMode = .Center
            hpNode.text = "HP:\(creature.hp)"
            addChild(hpNode)

            nutritionNode = SKLabelNode(fontNamed: "Arial")
            nutritionNode.position = CGPointMake(0, -14)
            nutritionNode.fontSize = 12
            nutritionNode.fontColor = UIColor.flatWhiteColor()
            nutritionNode.verticalAlignmentMode = .Center
            nutritionNode.text = "N:\(creature.nutrition)"
            addChild(nutritionNode)
        }
    }

    func changePosition(animated: Bool = true) {
        let newPosition = MapNode.tilePosition(cell: creature.currentCell)
        if animated {
            runAction(SKAction.moveTo(newPosition, duration: 0.4))
        } else {
            position = newPosition
        }
    }

    func changeDirection() {
        switch creature.currentDirection {
        case .Left, .LeftTop, .LeftBottom:
            spriteNode.xScale = 1.0
        case .Right, .RightTop, .RightBottom:
            spriteNode.xScale = -1.0
        }
    }

    func runDeadAnimation() {
        removeAllActions()

        spriteNode.colorBlendFactor = 0.8
        spriteNode.color = UIColor.flatGrayColorDark()

        let reduceAction = SKAction.scaleTo(0.0, duration: 1.0)
        runAction(reduceAction, completion: {
            self.removeFromParent()
            self.creature.decompose()
        })
    }

    func runActionCompletedAnimation(result: Bool) {
        switch creature.configuration.trophicLevel {
        case .Nutrition:
            fallthrough
        case .Producer:
            runProducerActionCompletedAnimation(result)
        case .Consumer1:
            runConsumer1ActionCompletedAnimation(result)
        case .Consumer2:
            runConsumer2ActionCompletedAnimation(result)
        }
    }

    func runProducerActionCompletedAnimation(result: Bool) {
        if !result {
            return
        }

        let circlePath = Circle(center: CGPointZero, radius: WorldNode.hexSize).cgpath
        let effectNode = SKShapeNode(path: circlePath)
        effectNode.lineWidth = 3
        effectNode.strokeColor = UIColor.flatOrangeColor()
        addChild(effectNode)

        effectNode.runAction(SKAction.scaleTo(0, duration: 0.5), completion: {
            effectNode.removeFromParent()
        })
    }

    func runConsumer1ActionCompletedAnimation(result: Bool) {

    }

    func runConsumer2ActionCompletedAnimation(result: Bool) {

    }

    func collisionCheck() {
        if creature.configuration.trophicLevel == .Producer {
            return
        }

        let creatureNodes = parent?.children.filter { $0 is CreatureNode } as? [CreatureNode]
        if creatureNodes == nil {
            return
        }

        let collisionCreatures = creatureNodes!.filter { $0 != self }
            .filter { !$0.creature.isDead }
            .filter { self.spriteNode.intersectsNode($0.spriteNode) }
            .map { $0.creature }

        for creature in collisionCreatures {
            self.creature.collisionTo(creature)
        }
    }
}
