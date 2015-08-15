import ChameleonFramework

extension UIColor {
    class func colorWithName(name: String) -> UIColor {
        switch name {
        case "Black":
            return UIColor.flatBlackColor()
        case "Blue":
            return UIColor.flatBlueColor()
        case "Brown":
            return UIColor.flatBrownColor()
        case "Coffee":
            return UIColor.flatCoffeeColor()
        case "ForestGreen":
            return UIColor.flatForestGreenColor()
        case "Gray":
            return UIColor.flatGrayColor()
        case "Green":
            return UIColor.flatGreenColor()
        case "Lime":
            return UIColor.flatLimeColor()
        case "Magenta":
            return UIColor.flatMagentaColor()
        case "Maroon":
            return UIColor.flatMaroonColor()
        case "Mint":
            return UIColor.flatMintColor()
        case "NavyBlue":
            return UIColor.flatNavyBlueColor()
        case "Orange":
            return UIColor.flatOrangeColor()
        case "Pink":
            return UIColor.flatPinkColor()
        case "Plum":
            return UIColor.flatPlumColor()
        case "PowderBlue":
            return UIColor.flatPowderBlueColor()
        case "Purple":
            return UIColor.flatPurpleColor()
        case "Red":
            return UIColor.flatRedColor()
        case "Sand":
            return UIColor.flatSandColor()
        case "SkyBlue":
            return UIColor.flatSkyBlueColor()
        case "Teal":
            return UIColor.flatTealColor()
        case "Watermelon":
            return UIColor.flatWatermelonColor()
        case "White":
            return UIColor.flatWhiteColor()
        case "Yellow":
            return UIColor.flatYellowColor()
        default:
            return UIColor.clearColor()
        }
    }

    class func darkColorWithName(name: String) -> UIColor {
        switch name {
        case "Black":
            return UIColor.flatBlackColorDark()
        case "Blue":
            return UIColor.flatBlueColorDark()
        case "Brown":
            return UIColor.flatBrownColorDark()
        case "Coffee":
            return UIColor.flatCoffeeColorDark()
        case "ForestGreen":
            return UIColor.flatForestGreenColorDark()
        case "Gray":
            return UIColor.flatGrayColorDark()
        case "Green":
            return UIColor.flatGreenColorDark()
        case "Lime":
            return UIColor.flatLimeColorDark()
        case "Magenta":
            return UIColor.flatMagentaColorDark()
        case "Maroon":
            return UIColor.flatMaroonColorDark()
        case "Mint":
            return UIColor.flatMintColorDark()
        case "NavyBlue":
            return UIColor.flatNavyBlueColorDark()
        case "Orange":
            return UIColor.flatOrangeColorDark()
        case "Pink":
            return UIColor.flatPinkColorDark()
        case "Plum":
            return UIColor.flatPlumColorDark()
        case "PowderBlue":
            return UIColor.flatPowderBlueColorDark()
        case "Purple":
            return UIColor.flatPurpleColorDark()
        case "Red":
            return UIColor.flatRedColorDark()
        case "Sand":
            return UIColor.flatSandColorDark()
        case "SkyBlue":
            return UIColor.flatSkyBlueColorDark()
        case "Teal":
            return UIColor.flatTealColorDark()
        case "Watermelon":
            return UIColor.flatWatermelonColorDark()
        case "White":
            return UIColor.flatWhiteColorDark()
        case "Yellow":
            return UIColor.flatYellowColorDark()
        default:
            return UIColor.clearColor()
        }
    }
}
