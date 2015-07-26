import SpriteKit
import RxSwift
import SwiftGraphics

class RoomNode : SKShapeNode {
    let room : Room
    let compositeDisposable = CompositeDisposable()

    // for Debug
    var nutritionNode: SKLabelNode?

    required init(room: Room) {
        self.room = room
        super.init()

        updatePath()
        setUpNodes()

        room.nutritionChanged
            >- subscribeNext { nutrition in
                nutritionNode?.text = "N:\(nutrition)"
            }
            >- compositeDisposable.addDisposable
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        compositeDisposable.dispose()
    }

    func roomStrokeColor() -> UIColor {
        switch room.type {
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

    func setUpNodes() {
        nutritionNode = SKLabelNode(fontNamed: "Arial")
        nutritionNode?.fontSize = 14
        nutritionNode?.fontColor = .flatTealColor()
        nutritionNode?.position = CGPointMake(0, -CGFloat(room.size) / 2 + 32)
        nutritionNode?.text = "N:\(room.nutrition)"
        addChild(nutritionNode!)
    }
}
