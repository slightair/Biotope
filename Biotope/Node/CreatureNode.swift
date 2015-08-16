import SpriteKit
import RxSwift
import ChameleonFramework

class CreatureNode: SKNode {
    let creature: Creature
    let compositeDisposable = CompositeDisposable()

    // for Debug
    var shapeNode: SKShapeNode!
    var hpLabelNode: SKLabelNode!

    required init(creature: Creature) {
        self.creature = creature
        super.init()

        setUpNodes()
        changePosition(animated: false)

        creature.currentCellChanged
            >- subscribeNext { cell in
                self.removeAllActions()
                self.changePosition()
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
                    self.hpLabelNode.text = "HP:\(hp.value)"
                case .Error(let error):
                    fallthrough
                case .Completed:
                    self.compositeDisposable.dispose()
                    self.runDeadAnimation()
                }
            }

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
        shapeNode = SKShapeNode(circleOfRadius: 24)
        shapeNode.strokeColor = UIColor.darkColorWithName(creature.configuration.debugInfo.colorName)
        shapeNode.fillColor = UIColor.colorWithName(creature.configuration.debugInfo.colorName)
        shapeNode.lineWidth = 3
        addChild(shapeNode)

        hpLabelNode = SKLabelNode(fontNamed: "Arial")
        hpLabelNode.fontSize = 12
        hpLabelNode.fontColor = UIColor.flatWhiteColor()
        hpLabelNode.verticalAlignmentMode = .Center
        hpLabelNode.text = "HP:\(creature.hp)"
        addChild(hpLabelNode)
    }

    func changePosition(animated: Bool = true) {
        let newPosition = MapNode.tilePosition(cell: creature.currentCell)
        if animated {
            runAction(SKAction.moveTo(newPosition, duration: 0.2))
        } else {
            position = newPosition
        }
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
        if creature.configuration.type != .Active {
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
