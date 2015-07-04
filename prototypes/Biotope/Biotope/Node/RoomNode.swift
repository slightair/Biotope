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
        let radius = CGFloat(room.size) / 2
        for (index, creature) in room.creatures.enumerate() {
            let creatureNode = CreatureNode()
            creatureNode.creature = creature
            let rad = M_PI / 16 * Double(index)
            creatureNode.position = CGPointMake(radius + radius * CGFloat(cos(rad)), radius + radius * CGFloat(sin(rad)))
            addChild(creatureNode)
        }
    }
}
