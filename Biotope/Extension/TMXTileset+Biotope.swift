extension TMXTileset {
    func creatureConfigurationForTileID(tileID: Int) -> CreatureConfiguration? {
        if self.name != "creatures" {
            return nil
        }

        let creatureID = tileID - self.firstGID;
        let configurationStore = CreatureConfigurationStore.defaultStore
        return configurationStore[creatureID];
    }
}
