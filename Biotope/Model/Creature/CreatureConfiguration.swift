import Foundation

struct CreatureConfiguration {
    enum Type {
        case Active, NonActive
    }

    struct DebugInfo {
        let colorName: String
    }

    let family: String
    let type: Type
    let speed: Int
    let sight: Int
    let initialHP: Int
    let initialNutrition: Int
    let agingInterval: Int
    let agingPoint: Int
    let food: [String]
    let debugInfo: DebugInfo

    // for debug
    static let AC01 = CreatureConfiguration(
        family: "AC01",
        type: .Active,
        speed: 3,
        sight: 3,
        initialHP: 50,
        initialNutrition: 10,
        agingInterval: 5,
        agingPoint: 3,
        food: ["NAC01"],
        debugInfo: DebugInfo(
            colorName: "Watermelon"
        )
    )

    static let NAC01 = CreatureConfiguration(
        family: "NAC01",
        type: .NonActive,
        speed: 0,
        sight: 0,
        initialHP: 10,
        initialNutrition: 4,
        agingInterval: 10,
        agingPoint: 1,
        food: [],
        debugInfo: DebugInfo(
            colorName: "Yellow"
        )
    )
}
