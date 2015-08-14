import SpriteKit
import RxSwift
import ChameleonFramework

class CreatureNode: SKNode {
    let creature: Creature
    let compositeDisposable = CompositeDisposable()

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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpNodes() {
        let shapeNode = SKShapeNode(circleOfRadius: 24)
        shapeNode.strokeColor = .flatGreenColorDark()
        shapeNode.fillColor = .flatGreenColor()
        shapeNode.lineWidth = 3
        addChild(shapeNode)
    }

    func changePosition(animated: Bool = true) {
        let newPosition = MapNode.tilePosition(cell: creature.currentCell)
        if animated {
            runAction(SKAction.moveTo(newPosition, duration: 0.2))
        } else {
            position = newPosition
        }
    }
}
