import SwiftGraphics

extension CGMutablePath {
    func addHex(position: CGPoint, size: CGFloat) -> CGMutablePath {
        move(CGPointMake(size * CGFloat(cos(M_PI_2)), size * CGFloat(sin(M_PI_2))) + position)
        for i in 0..<6 {
            let r = 2 * M_PI / 6.0 * Double(i + 1) + M_PI_2
            addLine(CGPointMake(size * CGFloat(cos(r)), size * CGFloat(sin(r))) + position)
        }
        return self
    }
}
