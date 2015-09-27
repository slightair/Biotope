import Foundation
import Himotoki

class CreatureConfigurationStore {
    static let defaultStore = CreatureConfigurationStore()

    var configurationDictionary: [Int: CreatureConfiguration] = [:]

    func load() {
        let filePath = NSBundle.mainBundle().pathForResource("creatures", ofType: "json")
        if filePath == nil {
            fatalError("file not found creatures.json")
        }

        let data = NSData(contentsOfFile: filePath!)

        do {
            let JSONObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject]
            if JSONObject == nil {
                fatalError("invalid configuration file")
            }
            parseCreatureConfigurations(JSONObject!)
        } catch let error {
            fatalError("error: \(error)")
        }
    }

    func parseCreatureConfigurations(object: [String: AnyObject]) {
        do {
            if let creatureConfigurations: [CreatureConfiguration] = try decodeArray(object["creatures"]!) {
                for (index, configuration) in creatureConfigurations.enumerate() {
                    configurationDictionary[index] = configuration
                }
            }
        } catch let error {
            fatalError("error: \(error)")
        }
    }

    subscript(id: Int) -> CreatureConfiguration {
        if (configurationDictionary.count == 0) {
            load()
        }
        return configurationDictionary[id]!
    }
}
