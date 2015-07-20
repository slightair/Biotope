import Foundation

class Elephant: ActiveCreature {
    override class func defaultConfiguration() -> CreatureConfiguration {
        return CreatureConfiguration(speed: 1, sight: 50)
    }

    override class func targets() -> [Creature.Type] {
        return [
            Mushroom.self
        ]
    }

    override func imageName() -> String {
        return "elephant"
    }
}
