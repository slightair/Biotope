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
        switch bridge.startRoom.configuration.type {
        case .Red:
            return .flatRedColor()
        case .Green:
            return .flatGreenColor()
        case .Blue:
            return .flatSkyBlueColor()
        case .Unknown:
            return .flatSandColor()
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
