import SpriteKit

class TextureAtlasStore {
    static let defaultStore = TextureAtlasStore()

    var textureAtlasDictionary: [String: TextureAtlas] = [:]

    func loadAll() {
        let creatures = [
            "flower",
            "rabbit",
        ]
        for creatureName in creatures {
            let textureAtlas = CreatureTextureAtlas(named: creatureName, slice: 4)
            textureAtlasDictionary[creatureName] = textureAtlas
        }
    }

    subscript(name: String) -> TextureAtlas! {
        return textureAtlasDictionary[name]
    }
}