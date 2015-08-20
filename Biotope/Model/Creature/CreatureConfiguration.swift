import Foundation

struct CreatureConfiguration {
    enum TrophicLevel: Int {
        case Nutrition, Producer, Consumer1, Consumer2

        func targetLevel() -> TrophicLevel {
            return TrophicLevel(rawValue: self.rawValue - 1)!
        }
    }

    struct DebugInfo {
        let colorName: String
    }

    let trophicLevel: TrophicLevel
    let speed: UInt
    let sight: UInt
    let initialHP: Int
    let initialNutrition: Int
    let agingInterval: Int
    let agingPoint: Int
    let actionInterval: Int
    let actionPower: Int
    let debugInfo: DebugInfo

    // for debug
    static let AC01 = CreatureConfiguration(
        trophicLevel: .Consumer1,
        speed: 3,
        sight: 3,
        initialHP: 50,
        initialNutrition: 10,
        agingInterval: 5,
        agingPoint: 3,
        actionInterval: 0,
        actionPower: 0,
        debugInfo: DebugInfo(
            colorName: "Watermelon"
        )
    )

    static let NAC01 = CreatureConfiguration(
        trophicLevel: .Producer,
        speed: 0,
        sight: 0,
        initialHP: 10,
        initialNutrition: 4,
        agingInterval: 10,
        agingPoint: 1,
        actionInterval: 3,
        actionPower: 2,
        debugInfo: DebugInfo(
            colorName: "Yellow"
        )
    )
}
