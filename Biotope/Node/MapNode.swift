import SpriteKit

class MapNode: SKNode {
    init(fileNamed: String) {
        super.init()

        let renderMap = TMXMapLoader.load(fileNamed)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
