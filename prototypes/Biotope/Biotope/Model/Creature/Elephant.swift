import Foundation

class Elephant: ActiveCreature {
    override class func defaultConfiguration() -> CreatureConfiguration {
        return CreatureConfiguration(
            speed: 10,
            sight: 50,
            initialHP: 12,
            agingInterval: 10,
            agingPoint: 3
        )
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
