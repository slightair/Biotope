import SpriteKit
import RxSwift
import ChameleonFramework
import SwiftGraphics

class CreatureNode: SKNode {
    static let AnimateActionKey = "animation"
    static let MoveDuration = 0.4

    let creature: Creature
    var spriteNode: SKSpriteNode!
    let compositeDisposable = CompositeDisposable()
    var playingActionAnimation = false

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
            distinctUntilChanged(creature.currentCellChanged)
            >- subscribeNext { cell in
                self.removeAllActions()
                self.changePosition()
            }
            >- compositeDisposable.addDisposable

        creature.walkStatusChanged
            >- subscribeNext { walkStatus in
                switch walkStatus {
                case .Idle:
                    if self.playingActionAnimation {
                        return
                    }
                    self.runAnimation(.Wait, repeat: true)
                default:
                    let timePerFrame = self.creatureTextureAtlas().timePerFrameForDuration(CreatureNode.MoveDuration)
                    self.runAnimation(.Move, repeat: true, timePerFrame: timePerFrame)
                }
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
            >- subscribeNext { action in
                self.runActionCompletedAnimation(action)
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

    func creatureTextureAtlas() -> CreatureTextureAtlas {
        return TextureAtlasStore.defaultStore[creature.configuration.textureName] as! CreatureTextureAtlas
    }

    func runAnimation(animation: CreatureTextureAtlas.Animation, repeat: Bool = false, timePerFrame: NSTimeInterval = CreatureTextureAtlas.DefaultTimePerFrame, completion: ((Void) -> Void)? = nil) {
        let textures = creatureTextureAtlas().texturesForAnimation(animation)
        var animateAction = SKAction.animateWithTextures(textures, timePerFrame: timePerFrame)

        spriteNode.removeActionForKey(CreatureNode.AnimateActionKey)
        if repeat {
            spriteNode.runAction(SKAction.repeatActionForever(animateAction), withKey: CreatureNode.AnimateActionKey)
        } else {
            spriteNode.runAction(animateAction, completion: {
                self.runAnimation(.Wait, repeat: true)
                completion?()
            })
        }
    }

    func setUpNodes() {
        spriteNode = SKSpriteNode(texture: creatureTextureAtlas().defaultTexture())
        addChild(spriteNode)
        runAnimation(.Wait, repeat: true)

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
            runAction(SKAction.moveTo(newPosition, duration: CreatureNode.MoveDuration))
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

    func runActionCompletedAnimation(action: Creature.Action) {
        switch action {
        case .Eat:
            playingActionAnimation = true
            runAnimation(.Eat, completion: {
                self.playingActionAnimation = false
            })
        }
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
