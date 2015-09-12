import SpriteKit
import Ono

extension ONOXMLElement {
    func StringAttribute(attr: String) -> String {
        return self[attr] as! String
    }

    func IntAttribute(attr: String) -> Int {
        return (self[attr] as! String).toInt()!
    }

    func BoolAttribute(attr: String, defaultValue: Bool) -> Bool {
        if let value = self[attr] as? String {
            return value.toInt() == 1
        } else {
            return defaultValue
        }
    }
}

extension String {
    subscript(integerRange: Range<Int>) -> String {
        let start = advance(self.startIndex, integerRange.startIndex)
        let end = advance(self.startIndex, integerRange.endIndex)
        return self.substringWithRange(start..<end)
    }

    func hexToInt() -> Int {
        return Int(strtoul(self, nil, 16))
    }
}

class TMXMapLoader {
    class func load(fileNamed: String) -> TMXMap {
        let filePath = NSBundle.mainBundle().pathForResource(fileNamed, ofType: "tmx")
        if filePath == nil {
            fatalError("file not found \(fileNamed).tmx")
        }

        let data = NSData(contentsOfFile: filePath!)
        var error: NSError?
        let document = ONOXMLDocument(data: data, error: &error)
        if error != nil {
            fatalError(error!.localizedDescription)
        }
        return parseTMXDocument(document)
    }

    private class func parseTMXDocument(document: ONOXMLDocument) -> TMXMap {
        if let mapElement = document.firstChildWithXPath("//map") {
            return parseMapElement(mapElement)
        }
        fatalError("invalid tmx file")
    }

    private class func parseMapElement(element: ONOXMLElement) -> TMXMap {
        return TMXMap(
            orientation: TMXMap.Orientation(rawValue: element.StringAttribute("orientation"))!,
            renderOrder: TMXMap.RenderOrder(rawValue: element.StringAttribute("renderorder"))!,
            width: element.IntAttribute("width"),
            height: element.IntAttribute("height"),
            tileWidth: element.IntAttribute("tilewidth"),
            tileHeight: element.IntAttribute("tileheight"),
            hexSideLength: element.IntAttribute("hexsidelength"),
            backgroundColor: colorWithHexString(element.StringAttribute("backgroundcolor")),
            properties: self.parseProperties(element.childrenWithTag("properties").first as? ONOXMLElement),
            tilesets: element.childrenWithTag("tileset").map{ self.parseTileset($0 as! ONOXMLElement) },
            layers: element.childrenWithTag("layer").map{ self.parseLayer($0 as! ONOXMLElement) }
        )
    }

    private class func colorWithHexString(hexString: String) -> SKColor {
        let red = hexString[1...2].hexToInt()
        let green = hexString[3...4].hexToInt()
        let blue = hexString[5...6].hexToInt()

        return SKColor(red: CGFloat(Double(red) / 255.0),
                     green: CGFloat(Double(green) / 255.0),
                      blue: CGFloat(Double(blue) / 255.0),
                     alpha: 1.0)
    }

    private class func parseProperties(element: ONOXMLElement?) -> [String: String] {
        if element == nil {
            return [:]
        }

        return element!.childrenWithTag("property").reduce([:]) { (var dict, e) in
            let key = e.StringAttribute("name")
            let value = e.StringAttribute("value")
            dict[key] = value

            return dict
        }
    }

    private class func parseTileset(element: ONOXMLElement) -> TMXTileset {
        return TMXTileset(
            firstGID: element.IntAttribute("firstgid"),
            name: element.StringAttribute("name"),
            tileWidth: element.IntAttribute("tilewidth"),
            tileHeight: element.IntAttribute("tileheight"),
            image: self.parseImage(element.firstChildWithTag("image"))
        )
    }

    private class func parseLayer(element: ONOXMLElement) -> TMXLayer {
        let dataElement = element.firstChildWithTag("data")
        if dataElement.StringAttribute("encoding") != "base64" || dataElement.StringAttribute("compression") != "zlib" {
            fatalError("unsupported data format")
        }

        let dataString = dataElement.stringValue().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let base64DecodedData = NSData(base64EncodedString: dataString, options: NSDataBase64DecodingOptions(0))
        let inflatedData = base64DecodedData!.inflatedData()!
        var data: [Int] = []

        var offset = 0
        while offset < inflatedData.length {
            var value: UInt32 = 0
            inflatedData.getBytes(&value, range: NSMakeRange(offset, sizeof(UInt32)))
            data.append(Int(value))
            offset += sizeof(UInt32)
        }

        return TMXLayer(
            name: element.StringAttribute("name"),
            width: element.IntAttribute("width"),
            height: element.IntAttribute("height"),
            visible: element.BoolAttribute("visible", defaultValue: true),
            data: data
        )
    }

    private class func parseImage(element: ONOXMLElement) -> TMXImage {
        return TMXImage(
            source: element.StringAttribute("source"),
            width: element.IntAttribute("width"),
            height: element.IntAttribute("height")
        )
    }
}