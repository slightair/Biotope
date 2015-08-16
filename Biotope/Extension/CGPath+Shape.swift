import SwiftGraphics

extension CGMutablePath {
    func addHex(#size: CGFloat) -> CGMutablePath {
        addHex(position: CGPointZero, size: size)
        return self
    }

    func addHex(#position: CGPoint, size: CGFloat) -> CGMutablePath {
        move(CGPointMake(size * CGFloat(cos(M_PI_2)), size * CGFloat(sin(M_PI_2))) + position)
        for i in 0..<6 {
            let r = 2 * M_PI / 6.0 * Double(i + 1) + M_PI_2
            addLine(CGPointMake(size * CGFloat(cos(r)), size * CGFloat(sin(r))) + position)
        }
        return self
    }

    func addArrow(#size: CGFloat) -> CGMutablePath {
        addArrow(position: CGPointZero, size: size)
        return self
    }

    func addArrow(#position: CGPoint, size: CGFloat) -> CGMutablePath {
        move(CGPointMake(size, 0) + position)

        let theta = M_PI_4
        addLine(CGPointMake(size * CGFloat(cos(M_PI - theta)),
                            size * CGFloat(sin(M_PI - theta))) + position)
        addLine(CGPointMake(size * CGFloat(cos(M_PI + theta)),
                            size * CGFloat(sin(M_PI + theta))) + position)
        addLine(CGPointMake(size, 0) + position)

        return self
    }
}
