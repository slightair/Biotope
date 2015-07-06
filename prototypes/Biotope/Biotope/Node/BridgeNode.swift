import SpriteKit

class BridgeNode: SKShapeNode {
    var bridge : Bridge! {
        didSet {
            updatePath()
        }
    }

    func bridgeStrokeColor() -> UIColor {
        switch bridge.startRoom.type {
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

    func updatePath() {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, CGFloat(bridge.startRoom.x), CGFloat(bridge.startRoom.y))
        CGPathAddLineToPoint(path, nil, CGFloat(bridge.endRoom.x), CGFloat(bridge.endRoom.y))

        self.path = path
        self.lineWidth = 20
        self.strokeColor = bridgeStrokeColor()
    }
}
