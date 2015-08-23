import SpriteKit
import SwiftGraphics

class MapNode: SKNode {
    let map: TMXMap
    var tilesetTextures: [Int: SKTexture] = [:]
    var tiles: [Int: SKSpriteNode] = [:]

    class func mapSize(map: TMXMap) -> CGSize {
        return CGSize(
            CGFloat(map.tileWidth * (map.width + 1) - map.tileWidth / 2),
            CGFloat((map.tileHeight + map.hexSideLength) / 2 * (map.height + 1))
        )
    }

    class func mapOffset(map: TMXMap) -> CGPoint {
        let mapSize = self.mapSize(map)
        let offsetX = -(mapSize.width - CGFloat(map.tileWidth)) / 2.0
        let offsetY = (mapSize.height - CGFloat(map.tileHeight)) / 2.0

        return CGPoint(offsetX, offsetY)
    }

    class func tilePosition(#x: Int, y: Int, forMap map: TMXMap, relative: Bool) -> CGPoint {
        var position = CGPoint(
            CGFloat(map.tileWidth * x + (y % 2 == 0 ? map.tileWidth / 2 : 0)),
            CGFloat(-(map.tileHeight + map.hexSideLength) / 2 * y)
        )
        if !relative {
            position += mapOffset(map)
        }
        return position
    }

    class func tilePosition(#index: Int, forMap map: TMXMap, relative: Bool = false) -> CGPoint {
        let x = index % map.width
        let y = index / map.width
        return tilePosition(x: x, y: y, forMap: map, relative: relative)
    }

    class func tilePosition(#cell: Cell, relative: Bool = false) -> CGPoint {
        return tilePosition(index: cell.index, forMap: cell.world.map, relative: relative)
    }

    required init(map: TMXMap) {
        self.map = map
        super.init()

        loadTilesets()
        setUpLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadTilesets() {
        for tileset in map.tilesets {
            let masterTexture = SKTexture(imageNamed: tileset.image.source)

            let tileWidthRatio = CGFloat(tileset.tileWidth) / CGFloat(tileset.image.width)
            let tileHeightRatio = CGFloat(tileset.tileHeight) / CGFloat(tileset.image.height)

            var index = tileset.firstGID
            for var yOffset: CGFloat = 0.0; yOffset < 1.0; yOffset += tileHeightRatio {
                for var xOffset:CGFloat = 0.0; xOffset < 1.0; xOffset += tileWidthRatio {
                    let rect = CGRectMake(xOffset,
                                          yOffset,
                                          tileWidthRatio,
                                          tileHeightRatio)

                    tilesetTextures[index] = SKTexture(rect: rect, inTexture: masterTexture)
                    index++
                }
            }
        }
    }

    func setUpLayers() {
        let mapSize = MapNode.mapSize(map)
        let mapOffset = MapNode.mapOffset(map)

        for layer in map.layers {
            if !layer.visible {
                continue
            }

            let layerNode = SKNode()
            layerNode.position = mapOffset

            var index = 0
            for var posY = 0; posY < map.height; posY++ {
                for var posX = 0; posX < map.width; posX++ {
                    let chipIndex = layer.data[index]

                    if chipIndex == 0 {
                        index++
                        continue
                    }

                    if let texture = tilesetTextures[chipIndex] {
                        let tile = SKSpriteNode(texture: texture)
                        tile.position = MapNode.tilePosition(x: posX, y: posY, forMap: map, relative: true)
                        tiles[index] = tile
                        layerNode.addChild(tile)
                    }
                    index++
                }
            }
            addChild(layerNode)
        }
    }
}
