import Foundation

class Mushroom: NonActiveCreature {
    override class func defaultConfiguration() -> CreatureConfiguration {
        return CreatureConfiguration(
            speed: 0,
            sight: 0,
            initialHP: 10,
            agingInterval: 10,
            agingPoint: 1
        )
    }

    override func imageName() -> String {
        return "mushroom"
    }
}
