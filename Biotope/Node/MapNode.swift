import SpriteKit

class MapNode: SKShapeNode {
    let renderMap: TMXMap
    var tilesetTextures: [Int: SKTexture] = [:]

    required init(fileNamed: String) {
        renderMap = TMXMapLoader.load(fileNamed)
        super.init()

        loadTilesets()
        setUpLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadTilesets() {
        for tileset in renderMap.tilesets {
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
        let mapSize = CGSize(
            CGFloat(renderMap.tileWidth * (renderMap.width + 1) - renderMap.tileWidth / 2),
            CGFloat((renderMap.tileHeight + renderMap.hexSideLength) / 2 * (renderMap.height + 1))
        )

        self.fillColor = renderMap.backgroundColor
        self.path = CGPathCreateWithRect(CGRectMake(-mapSize.width / 2, -mapSize.height / 2, mapSize.width, mapSize.height), nil)

        let mapXOffset = -(mapSize.width - CGFloat(renderMap.tileWidth)) / 2.0
        let mapYOffset = (mapSize.height - CGFloat(renderMap.tileHeight)) / 2.0

        for layer in renderMap.layers {
            if !layer.visible {
                continue
            }

            let layerNode = SKNode()
            layerNode.position = CGPoint(mapXOffset, mapYOffset)

            var index = 0
            for var posY = 0; posY < renderMap.height; posY++ {
                for var posX = 0; posX < renderMap.width; posX++ {
                    let chipIndex = layer.data[index]
                    index++

                    if chipIndex == 0 {
                        continue
                    }

                    if let texture = tilesetTextures[chipIndex] {
                        let chipNode = SKSpriteNode(texture: texture)
                        chipNode.position = CGPoint(
                            CGFloat(renderMap.tileWidth * posX + (posY % 2 == 0 ? renderMap.tileWidth / 2 : 0)),
                            CGFloat(-(renderMap.tileHeight + renderMap.hexSideLength) / 2 * posY)
                        )
                        chipNode.zPosition = CGFloat(index)
                        layerNode.addChild(chipNode)
                    }
                }
            }
            addChild(layerNode)
        }
    }
}
