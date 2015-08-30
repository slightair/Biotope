import SpriteKit

class CreatureTextureAtlas: TextureAtlas {
    enum Animation: Int {
        case Born, Wait, Eat, Move

        static let values: [Animation] = [.Born, .Wait, .Eat, .Move]
    }

    static let DefaultTimePerFrame: NSTimeInterval = 0.2

    let imageName: String
    let slice: Int
    let masterTexture: SKTexture

    init!(named name: String, slice: Int) {
        self.imageName = name
        self.slice = slice
        self.masterTexture = SKTexture(imageNamed: name)
    }

    func textureSize() -> CGSize {
        let animationsCount = Animation.values.count
        let width = CGFloat(1.0 / Double(slice))
        let height = CGFloat(1.0 / Double(animationsCount))

        return CGSizeMake(width, height)
    }

    func texturesForAnimation(animation: Animation) -> [SKTexture] {
        let size = textureSize()
        return (0..<slice).map { index in
            let rect = CGRectMake(size.width * CGFloat(index), 1.0 - size.height * CGFloat(animation.rawValue + 1), size.width, size.height)
            return SKTexture(rect: rect, inTexture: self.masterTexture)
        }
    }

    func defaultTexture() -> SKTexture {
        let size = textureSize()
        let rect = CGRectMake(0, 1.0 - size.height, size.width, size.height)
        return SKTexture(rect: rect, inTexture: self.masterTexture)
    }

    func timePerFrameForDuration(duration: NSTimeInterval) -> NSTimeInterval {
        return duration / NSTimeInterval(slice)
    }
}