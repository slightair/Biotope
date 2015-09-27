import SpriteKit
import RxSwift
import ChameleonFramework

class CreatureCountNode: SKNode {
    static let Margin = CGPointMake(4, 4)
    static let Padding = CGPointMake(10, 0)
    static let Size = CGSizeMake(372, 32)

    let world: World
    let compositeDisposable = CompositeDisposable()

    init (_ world: World) {
        self.world = world

        super.init()

        setUpNodes()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        compositeDisposable.dispose()
    }

    func leftSideEdge() -> CGFloat {
        return -CreatureCountNode.Size.width / 2 + CreatureCountNode.Padding.x
    }

    func defaultLabelNode() -> SKLabelNode {
        let labelNode = SKLabelNode(fontNamed: "Press Start 2P")
        labelNode.fontSize = 16
        labelNode.verticalAlignmentMode = .Center
        labelNode.horizontalAlignmentMode = .Left
        labelNode.fontColor = .flatWhiteColor()

        return labelNode
    }

    func textureNodeForName(name: String) -> SKSpriteNode {
        let textureAtlas = TextureAtlasStore.defaultStore[name] as! CreatureTextureAtlas
        let texture = textureAtlas.texturesForAnimation(.Wait).first
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.xScale = 0.5
        spriteNode.yScale = 0.5
        return spriteNode
    }

    func setUpNodes() {
        let backgroundNode = SKShapeNode(rectOfSize: CreatureCountNode.Size)
        backgroundNode.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        backgroundNode.lineWidth = 0
        backgroundNode.position = CreatureCountNode.Margin
        addChild(backgroundNode);

        let nutritionLabel = defaultLabelNode()
        nutritionLabel.text = "N:0000"
        nutritionLabel.position = CGPointMake(leftSideEdge(), 0)
        backgroundNode.addChild(nutritionLabel);

        var xOffset = leftSideEdge() + 120

        let producerSpriteNode = textureNodeForName("flower")
        producerSpriteNode.position = CGPointMake(xOffset, 0)
        backgroundNode.addChild(producerSpriteNode)
        xOffset += 16

        let producerCountLabel = defaultLabelNode()
        producerCountLabel.text = "000"
        producerCountLabel.position = CGPointMake(xOffset, 0)
        backgroundNode.addChild(producerCountLabel);
        xOffset += 68

        let consumer1SpriteNode = textureNodeForName("rabbit")
        consumer1SpriteNode.position = CGPointMake(xOffset, 0)
        backgroundNode.addChild(consumer1SpriteNode)
        xOffset += 16

        let consumer1CountLabel = defaultLabelNode()
        consumer1CountLabel.text = "000"
        consumer1CountLabel.position = CGPointMake(xOffset, 0)
        backgroundNode.addChild(consumer1CountLabel);
        xOffset += 68

        let consumer2SpriteNode = textureNodeForName("dragon")
        consumer2SpriteNode.position = CGPointMake(xOffset, 0)
        backgroundNode.addChild(consumer2SpriteNode)
        xOffset += 16

        let consumer2CountLabel = defaultLabelNode()
        consumer2CountLabel.text = "000"
        consumer2CountLabel.position = CGPointMake(xOffset, 0)
        backgroundNode.addChild(consumer2CountLabel);
        xOffset += 68

        compositeDisposable.addDisposable(
            GameScenePaceMaker.defaultPaceMaker.pace.subscribeNext { interval in
                nutritionLabel.text = String(format: "N:%04d", self.world.nutritionCount)
                producerCountLabel.text = String(format: "%03d", self.world.producerCount)
                consumer1CountLabel.text = String(format: "%03d", self.world.consumer1Count)
                consumer2CountLabel.text = String(format: "%03d", self.world.consumer2Count)
            }
        )
    }
}
