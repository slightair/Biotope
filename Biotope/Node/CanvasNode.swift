import SpriteKit
import ChameleonFramework
import SwiftGraphics

class CanvasNode: SKShapeNode {
    let lineInterval: CGFloat = 64

    class func defaultNode() -> CanvasNode {
        let node = CanvasNode(rectOfSize:CGSizeMake(2048, 2048))
        node.setUpPath()

        return node
    }

    func setUpPath() {
        let path = CGPathCreateMutable()

        CGPathAddRect(path, nil, frame)

        let numHorizontalLines = Int(frame.height / lineInterval)
        let numVerticalLines = Int(frame.width / lineInterval)

        for x in -((numVerticalLines / 2) - 1)..<(numVerticalLines / 2) {
            let xPos = lineInterval * CGFloat(x)
            path.move(CGPoint(xPos, CGRectGetMinY(frame)))
            path.addLine(CGPoint(xPos, CGRectGetMaxY(frame)))
        }

        for y in -((numHorizontalLines / 2) - 1)..<(numHorizontalLines / 2) {
            let yPos = lineInterval * CGFloat(y)
            path.move(CGPoint(CGRectGetMinX(frame), yPos))
            path.addLine(CGPoint(CGRectGetMaxX(frame), yPos))
        }

        self.path = path
        self.strokeColor = UIColor.flatGrayColor()
        self.fillColor = UIColor.whiteColor()
    }
}
