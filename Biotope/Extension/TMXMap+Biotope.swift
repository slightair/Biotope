extension TMXMap {
    func creaturesTileset() -> TMXTileset? {
        return tilesets.filter { $0.name == "creatures" }.first
    }

    func creaturesLayer() -> TMXLayer? {
        return layers.filter { $0.name == "creatures" }.first
    }
}
