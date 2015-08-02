import SpriteKit

struct TMXMap {
    enum Orientation: String {
        case Hexagonal = "hexagonal"
    }

    enum RenderOrder: String {
        case RightDown = "right-down"
    }

    let orientation: Orientation
    let renderOrder: RenderOrder
    let width: Int
    let height: Int
    let tileWidth: Int
    let tileHeight: Int
    let hexSideLength: Int
    let backgroundColor: SKColor
    let tilesets: [TMXTileset]
    let layers: [TMXLayer]
}
