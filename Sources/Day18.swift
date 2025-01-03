import Foundation

struct Day18: AdventDay {
    var data: String

    private let example: String = """
        5,4
        4,2
        4,5
        3,0
        2,1
        6,3
        2,4
        1,5
        0,6
        3,3
        2,6
        5,1
        1,2
        5,5
        2,5
        6,5
        1,4
        0,4
        6,4
        1,1
        6,1
        1,0
        0,5
        1,6
        2,0
        """

    private func parse(_ data: String) -> [(x: Int, y: Int)] {
        data
            .components(separatedBy: .whitespacesAndNewlines)
            .map { row in
                let splitted = row.split(separator: ",")
                return splitted.map { Int($0)! }
            }
            .filter { !$0.isEmpty }
            .map { coords in (x: coords[0], y: coords[1]) }
    }

    private func memorySpace(locations: [(x: Int, y: Int)]) -> [[Character]] {
        let (W, H) = (71, 71)
        // let (W, H) = (7, 7)
        var grid = Array(repeating: Array(repeating: Character("."), count: W), count: H)
        for (x, y) in locations {
            grid[y][x] = "#"
        }
        return grid
    }

    private func bfs(
        grid: [[Character]],
        start: (x: Int, y: Int),
        end: (x: Int, y: Int)
    ) -> Int? {
        typealias Pose = (x: Int, y: Int)
        let (W, H) = (grid[0].count, grid.count)

        var costs: [[Int]: Int] = [[start.x, start.y]: 0]
        var queue: [(Pose, [Pose], Int)] = [(start, [], 0)]
        var pathsAndCosts: [(path: [Pose], cost: Int)] = []

        while let poseAndPath = queue.popLast() {
            let (pose, path, currCost) = poseAndPath

            if pose.x == end.x, pose.y == end.y {
                pathsAndCosts.append((path + [pose], currCost))
            }

            let nbrs: [(x: Int, y: Int)] = [(0, 1), (0, -1), (1, 0), (-1, 0)]
                .map { (dx, dy) in (pose.x + dx, pose.y + dy) }
                .filter { p in 0 <= p.x && p.x < W && 0 <= p.y && p.y < H }
                .filter { p in grid[p.y][p.x] != "#" }

            for nbr in nbrs {
                let dCost = 1
                let newCost = costs[[pose.x, pose.y]]! + dCost

                if newCost < costs[[nbr.x, nbr.y], default: Int.max] {
                    costs[[nbr.x, nbr.y]] = newCost
                    queue.insert((nbr, path + [pose], newCost), at: 0)
                }
            }
        }

        let best = costs.keys
            .filter { $0[0] == end.x && $0[1] == end.y }
            .min { costs[$0, default: Int.max] < costs[$1, default: Int.max] }

        guard let best, let bestCost = costs[best] else { return nil }

        let bestPaths =
            pathsAndCosts
            .filter { _, cost in cost == bestCost }
            .map(\.path)

        // Print the result
        // for path in bestPaths {
        //     var printGrid = grid
        //     for pose in path {
        //         printGrid[pose.y][pose.x] = "O"
        //     }
        //     for row in printGrid {
        //         print(row.map { String($0) }.joined())
        //     }
        //     print()
        // }

        return costs[best]!
    }
    init(data: String) {
        self.data = data
    }

    func part1() -> Int {
        let ls = self.parse(self.data)
        let ms = self.memorySpace(locations: Array(ls[0..<1024]))
        for row in ms {
            print(row.map { String($0) }.joined())
        }
        print()
        guard let result = self.bfs(grid: ms, start: (0, 0), end: (6, 6)) else {
            return -1
        }
        return result
    }

    // Can just check which bit falls on any of the valid paths or something
    // like that but whatever
    func part2() -> Int {
        let ls = self.parse(self.data)
        for i in 0..<ls.count {
            let ms = self.memorySpace(locations: Array(ls[0..<i]))
            let result = self.bfs(grid: ms, start: (0, 0), end: (70, 70))
            if result == nil {
                print(ls[i - 1])
                return 1
            }
        }
        return -1
    }
}
