import SpriteKit

class RoomNode : SKShapeNode {
    var room : Room! {
        didSet {
            updatePath()
            updateCreatures()
        }
    }

    func roomStrokeColor() -> UIColor {
        switch room.type {
        case .Red:
            return UIColor.flatRedColor()
        case .Green:
            return UIColor.flatGreenColor()
        case .Blue:
            return UIColor.flatSkyBlueColor()
        case .Unknown:
            return UIColor.flatSandColor()
        }
    }

    func roomFillColor() -> UIColor {
        return roomStrokeColor().colorWithAlphaComponent(0.4)
    }

    func updatePath() {
        let size = CGFloat(room.size)
        self.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, size, size), nil)

        self.lineWidth = 5
        self.strokeColor = roomStrokeColor()
        self.fillColor = roomFillColor()
    }

    func updateCreatures() {
        for (index, creature) in room.creatures.enumerate() {
            let creatureNode = CreatureNode()
            creatureNode.creature = creature

            let creatureAction = createCreatureAction(index)
            creatureNode.runAction(creatureAction)

            addChild(creatureNode)
        }
    }

    func createCreatureAction(index : Int) -> SKAction {
        let radius = CGFloat(room.size) / 2

        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, radius, radius)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 16 * CGFloat(index))
        transform = CGAffineTransformTranslate(transform, -radius, -radius)

        let trackPath = CGPathCreateCopyByTransformingPath(self.path!, &transform)
        let moveAction = SKAction.followPath(trackPath, asOffset: false, orientToPath: true, duration: 8.0)
        let moveForeverAction = SKAction.repeatActionForever(moveAction)
        let expandAction = SKAction.scaleTo(1.1, duration: 0.5)
        let reduceAction = SKAction.scaleTo(0.9, duration: 0.5)
        let expandAndReduceForeverAction = SKAction.repeatActionForever(SKAction.sequence([expandAction, reduceAction]))

        return SKAction.group([moveForeverAction, expandAndReduceForeverAction])
    }
}
