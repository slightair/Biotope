import Foundation

class Mushroom: NonActiveCreature {
    override class func defaultConfiguration() -> CreatureConfiguration {
        return CreatureConfiguration(speed: 0, sight: 0)
    }

    override func imageName() -> String {
        return "mushroom"
    }
}
