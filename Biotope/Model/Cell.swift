import Foundation

func ==(lhs: Cell, rhs: Cell) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Cell: Hashable {
    enum Direction: Int {
        case Right, RightTop, LeftTop, Left, LeftBottom, RightBottom

        static let values: [Direction] = [.Right, .RightTop, .LeftTop, .Left, .LeftBottom, .RightBottom]
    }

    let world: World
    let index: Int

    var x: Int {
        return index % world.map.width
    }

    var y: Int {
        return index / world.map.width
    }

    var hashValue: Int {
        return index
    }

    private var rightCell: Cell?
    private var rightTopCell: Cell?
    private var leftTopCell: Cell?
    private var leftCell: Cell?
    private var leftBottomCell: Cell?
    private var rightBottomCell: Cell?

    init(world: World, index: Int) {
        self.world = world
        self.index = index
    }

    subscript(direction: Direction) -> Cell? {
        get {
            switch direction {
            case .Right:
                return rightCell
            case .RightTop:
                return rightTopCell
            case .LeftTop:
                return leftTopCell
            case .Left:
                return leftCell
            case .LeftBottom:
                return leftBottomCell
            case .RightBottom:
                return rightBottomCell
            }
        }
        set(cell) {
            switch direction {
            case .Right:
                rightCell = cell
            case .RightTop:
                rightTopCell = cell
            case .LeftTop:
                leftTopCell = cell
            case .Left:
                leftCell = cell
            case .LeftBottom:
                leftBottomCell = cell
            case .RightBottom:
                rightBottomCell = cell
            }
        }
    }
}
