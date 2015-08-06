import Foundation

class World {
    let map: TMXMap
    var cells: [Cell]!

    init(named name: String) {
        self.map = TMXMapLoader.load(name)

        setUpCells()
    }

    func setUpCells() {
        var cells: [Cell] = []

        for index in 0..<(self.map.width * self.map.height) {
            let cell = Cell(index: index)
            cells.append(cell)
        }

        var index = 0
        for y in 0..<self.map.height {
            for x in 0..<self.map.width {
                let cell = cells[index]

                if 0 < x && x < self.map.width {
                    cell[.Left] = cells[index - 1]
                }
                if 0 <= x && x < self.map.width - 1 {
                    cell[.Right] = cells[index + 1]
                }

                if y % 2 == 0 {
                    if 0 <= x && x < self.map.width && 0 < y && y < self.map.height - 1 {
                        cell[.LeftTop] = cells[index - self.map.width]
                    }
                    if 0 <= x && x < self.map.width - 1 && 0 < y && y < self.map.height - 1 {
                        cell[.RightTop] = cells[index - self.map.width + 1]
                    }
                    if 0 <= x && x < self.map.width && 0 <= y && y < self.map.height - 1 {
                        cell[.LeftBottom] = cells[index + self.map.width]
                    }
                    if 0 <= x && x < self.map.width - 1 && 0 <= y && y < self.map.height - 1 {
                        cell[.RightBottom] = cells[index + self.map.width + 1]
                    }
                } else {
                    if 0 <= x && x < self.map.width && 0 < y && y < self.map.height {
                        cell[.RightTop] = cells[index - self.map.width]
                    }
                    if 0 < x && x < self.map.width && 0 < y && y < self.map.height {
                        cell[.LeftTop] = cells[index - self.map.width - 1]
                    }
                    if 0 < x && x < self.map.width && 0 < y && y < self.map.height - 1 {
                        cell[.LeftBottom] = cells[index + self.map.width - 1]
                    }
                    if 0 <= x && x < self.map.width && 0 < y && y < self.map.height - 1 {
                        cell[.RightBottom] = cells[index + self.map.width]
                    }
                }
                index++
            }
        }
        self.cells = cells
    }
}
