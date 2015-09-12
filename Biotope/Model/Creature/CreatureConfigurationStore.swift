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
        var error: NSError?
        let JSONObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: &error) as? [String: AnyObject]
        if error != nil {
            fatalError(error!.localizedDescription)
        }
        if JSONObject == nil {
            fatalError("invalid configuration file")
        }

        parseCreatureConfigurations(JSONObject!)
    }

    func parseCreatureConfigurations(object: [String: AnyObject]) {
        if let creaturesInfo = object["creatures"] as? [AnyObject] {
            if let creatureConfigurations: [CreatureConfiguration] = decodeArray(creaturesInfo) {
                for (index, configuration) in enumerate(creatureConfigurations) {
                    configurationDictionary[index] = configuration
                }
            }
        }
    }

    subscript(id: Int) -> CreatureConfiguration {
        if (configurationDictionary.count == 0) {
            load()
        }
        return configurationDictionary[id]!
    }
}
