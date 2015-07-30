import Foundation

struct RoomConfiguration {
    enum Type {
        case Red, Green, Blue, Unknown
    }

    let type: Type
    let position: Position
    let size: Double
    let initialNutrition: Int
    let emergingStepCountInterval: Int
    let emergingCreatures: [Creature.Type]
    let emergingMaxCount: Int
}