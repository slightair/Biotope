import Foundation

struct TMXLayer {
    let name: String
    let width: Int
    let height: Int
    let visible: Bool
    let data: [Int]

    subscript(index: Int) -> Int {
        return data[index]
    }
}
