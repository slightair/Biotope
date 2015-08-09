import Foundation

func ==(lhs: PathNode, rhs: PathNode) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class PathNode: Hashable {
    enum Status {
        case Open, Closed
    }

    let cell: Cell
    var status: Status
    let cost: Int
    let heuristicCost: Int
    let parent: PathNode?
    var score: Int {
        return cost * 1000 + heuristicCost
    }

    var hashValue: Int {
        return cell.index
    }

    init(cell: Cell, cost: Int, heuristicCost: Int, parent: PathNode? = nil) {
        self.cell = cell
        self.status = .Open
        self.cost = cost
        self.heuristicCost = heuristicCost
        self.parent = parent
    }

    func close() {
        status = .Closed
    }

    func route() -> [Cell] {
        var cells = [cell]
        var nextParent = parent
        while nextParent != nil {
            cells.append(nextParent!.cell)
            nextParent = nextParent!.parent
        }
        return reverse(cells)
    }
}
