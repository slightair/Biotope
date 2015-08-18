import SpriteKit
import RxSwift
import ChameleonFramework

class CreatureNode: SKNode {
    let creature: Creature
    let compositeDisposable = CompositeDisposable()

    // for Debug
    var shapeNode: SKShapeNode!
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

        creature.targetPathFinderChanged
            >- subscribeNext { pathFinder in
                self.removeAllActions()
                self.changePosition(animated: false)
            }
            >- compositeDisposable.addDisposable

        creature.life
            >- subscribe { event in
                switch event {
                case .Next(let hp):
                    self.hpNode.text = "HP:\(hp.value)"
                case .Error(let error):
                    fallthrough
                case .Completed:
                    self.compositeDisposable.dispose()
                    self.runDeadAnimation()
                }
            }

        creature.nutritionChanged
            >- subscribeNext { nutrition in
                self.nutritionNode.text = "N:\(nutrition)"
            }
            >- compositeDisposable.addDisposable

        GameScenePaceMaker.defaultPaceMaker.pace
            >- subscribeNext { currentTime in
                self.collisionCheck()
            }
            >- compositeDisposable.addDisposable
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpNodes() {
        shapeNode = SKShapeNode(path: CGPathCreateMutable().addArrow(size: 36))
        shapeNode.strokeColor = UIColor.darkColorWithName(creature.configuration.debugInfo.colorName)
        shapeNode.fillColor = UIColor.colorWithName(creature.configuration.debugInfo.colorName)
        shapeNode.lineWidth = 3
        addChild(shapeNode)

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

    func changePosition(animated: Bool = true) {
        let newPosition = MapNode.tilePosition(cell: creature.currentCell)
        if animated {
            runAction(SKAction.moveTo(newPosition, duration: 0.2))
        } else {
            position = newPosition
        }
    }

    func changeDirection() {
        let angle = CGFloat(2 * M_PI / Double(Cell.Direction.values.count) * Double(creature.currentDirection.rawValue))
        let rotateAction = SKAction.rotateToAngle(angle, duration: 0)
        self.shapeNode.runAction(rotateAction)
    }

    func runDeadAnimation() {
        removeAllActions()

        shapeNode.strokeColor = UIColor.flatGrayColorDark()
        shapeNode.fillColor = UIColor.flatGrayColor()

        let reduceAction = SKAction.scaleTo(0.0, duration: 1.0)
        runAction(reduceAction, completion: {
            self.removeFromParent()
            self.creature.decompose()
        })
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
            .filter { self.shapeNode.intersectsNode($0.shapeNode) }
            .map { $0.creature }

        for creature in collisionCreatures {
            self.creature.collisionTo(creature)
        }
    }
}
