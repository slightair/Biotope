import Foundation

class Cell {
    enum Direction: Int {
        case Right, RightTop, LeftTop, Left, LeftBottom, RightBottom

        static let values: [Direction] = [.Right, .RightTop, .LeftTop, .Left, .LeftBottom, .RightBottom]
    }

    let index: Int
    let map: TMXMap

    private var rightCell: Cell?
    private var rightTopCell: Cell?
    private var leftTopCell: Cell?
    private var leftCell: Cell?
    private var leftBottomCell: Cell?
    private var rightBottomCell: Cell?

    init(index: Int, map: TMXMap) {
        self.index = index
        self.map = map
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
