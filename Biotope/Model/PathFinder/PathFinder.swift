import Foundation

class PathFinder {
    enum Point {
        case Point(Cell)
        case End
    }

    let source: Cell
    let destination: Cell
    var nodes: [Int: PathNode] = [:]
    var openedNodes = Set<PathNode>()
    var result: [Cell]? = nil
    var calculated = false
    var hasRoute: Bool {
        return calculated && result != nil
    }
    var currentPointIndex = 0

    init(source: Cell, destination: Cell) {
        self.source = source
        self.destination = destination
    }

    func calculate() -> [Cell]? {
        if calculated {
            return result
        }

        var criteria: PathNode? = createNode(current: source, cost: 0)
        nodes[criteria!.cell.index] = criteria!

        while !isSolved(criteria) {
            openSurroundingNodes(criteria!)
            criteria = nextCriteria()
        }

        if criteria?.cell.index == destination.index {
            result = criteria!.route()
        }

        calculated = true

        return result;
    }

    func createNode(#current: Cell, cost: Int, parent: PathNode? = nil) -> PathNode {
        return PathNode(
            cell: current,
            cost: cost,
            heuristicCost: heuristicCost(source: current, destination: destination),
            parent: parent
        )
    }

    func isSolved(criteria: PathNode?) -> Bool {
        if criteria == nil {
            return true
        }
        if criteria!.cost > 10 {
            return true
        }
        if criteria!.cell.index == destination.index {
            return true
        }
        return false
    }

    func openSurroundingNodes(node: PathNode) {
        for direction in Cell.Direction.values {
            if let nextCell = node.cell[direction] {
                if nodes[nextCell.index] == nil {
                    let newNode = createNode(current: nextCell, cost: node.cost + 1, parent: node)
                    nodes[nextCell.index] = newNode
                    openedNodes.insert(newNode)
                }
            }
        }
        node.close()
        openedNodes.remove(node)
    }

    func nextCriteria() -> PathNode? {
        var criteria: PathNode? = nil
        var score = Int(INT32_MAX)
        for node in openedNodes {
            if node.score < score {
                score = node.score
                criteria = node
            }
        }
        return criteria
    }

    func heuristicCost(#source: Cell, destination: Cell) -> Int {
        return source.distance(destination)
    }

    func nextPoint() -> Point {
        currentPointIndex++

        if !hasRoute || currentPointIndex >= result!.count {
            return .End
        }

        let point = result![currentPointIndex]
        return .Point(point)
    }
}