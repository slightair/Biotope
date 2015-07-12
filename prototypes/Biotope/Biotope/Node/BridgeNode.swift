import SpriteKit

class BridgeNode: SKShapeNode {
    let bridge: Bridge

    required init(bridge: Bridge) {
        self.bridge = bridge
        super.init()

        updatePath()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        CGPathMoveToPoint(path, nil, CGFloat(bridge.startRoom.position.x), CGFloat(bridge.startRoom.position.y))
        CGPathAddLineToPoint(path, nil, CGFloat(bridge.endRoom.position.x), CGFloat(bridge.endRoom.position.y))

        self.path = path
        self.lineWidth = 20
        self.strokeColor = bridgeStrokeColor()
    }
}
