import SpriteKit
import SwiftGraphics

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
        path.move(bridge.startRoom.position.CGPointValue)
        path.addLine(bridge.endRoom.position.CGPointValue)

        self.path = path
        self.lineWidth = 20
        self.strokeColor = bridgeStrokeColor()
    }
}
