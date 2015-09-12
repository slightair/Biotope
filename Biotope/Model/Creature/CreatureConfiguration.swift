import Foundation
import Himotoki

struct CreatureConfiguration: Decodable {
    enum TrophicLevel: Int {
        case Nutrition = 0
        case Producer = 100
        case Consumer1 = 200
        case Consumer2 = 300

        func targetLevel() -> TrophicLevel {
            switch self {
            case Nutrition:
                fallthrough
            case Producer:
                return Nutrition;
            case Consumer1:
                return Producer
            case .Consumer2:
                return Consumer1
            }
        }
    }

    let name: String
    let trophicLevel: TrophicLevel
    let speed: UInt
    let sight: UInt
    let initialHP: Int
    let initialNutrition: Int
    let moveInterval: Int
    let agingInterval: Int
    let agingPoint: Int
    let actionInterval: Int
    let actionPower: Int
    let textureName: String

    static func decode(e: Extractor) -> CreatureConfiguration? {
        let create = { CreatureConfiguration($0) }

        return build(create)(
            e <| "name",
            TrophicLevel(rawValue: (e <| "trophicLevel")!),
            e <| "speed",
            e <| "sight",
            e <| "initialHP",
            e <| "initialNutrition",
            e <| "moveInterval",
            e <| "agingInterval",
            e <| "agingPoint",
            e <| "actionInterval",
            e <| "actionPower",
            e <| "textureName"
        )
    }
}
