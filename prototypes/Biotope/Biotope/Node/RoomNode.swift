import SpriteKit
import SwiftGraphics

class RoomNode : SKShapeNode {
    let room : Room

    required init(room: Room) {
        self.room = room
        super.init()

        updatePath()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.path = Circle(center: CGPoint(), radius: size / 2).cgpath

        self.lineWidth = 5
        self.strokeColor = roomStrokeColor()
        self.fillColor = roomFillColor()
    }
}
