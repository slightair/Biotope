import SpriteKit
import ChameleonFramework

class WorldCanvasNode: SKShapeNode {
    let lineInterval : CGFloat = 64.0

    func setUpLines() {
        let path = CGPathCreateMutable()

        CGPathAddRect(path, nil, CGRectMake(0, 0, frame.width, frame.height))

        let numHorizontalLines = Int(frame.height / lineInterval)
        let numVerticalLines = Int(frame.width / lineInterval)

        for x in 1..<numVerticalLines {
            CGPathMoveToPoint(path, nil, lineInterval * CGFloat(x), 0)
            CGPathAddLineToPoint(path, nil, lineInterval * CGFloat(x), frame.height)
        }

        for y in 1..<numHorizontalLines {
            CGPathMoveToPoint(path, nil, 0, lineInterval * CGFloat(y))
            CGPathAddLineToPoint(path, nil, frame.width, lineInterval * CGFloat(y))
        }

        self.path = path
        self.strokeColor = UIColor.flatGreenColor()
        self.fillColor = UIColor.whiteColor()
    }
}