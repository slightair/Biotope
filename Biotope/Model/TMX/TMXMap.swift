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
    let properties: [String: String]
    let tilesets: [TMXTileset]
    let layers: [TMXLayer]

    func tilesetForName(name: String) -> TMXTileset? {
        return tilesets.filter { $0.name == name }.first
    }

    func layerForName(name: String) -> TMXLayer? {
        return layers.filter { $0.name == name }.first
    }
}
