import Foundation

struct Day22: AdventDay {
    var data: String

    private let example: String = """
        1
        10
        100
        2024
        """

    init(data: String) {
        self.data = data
    }

    private func parse(_ data: String) -> [Int] {
        data.split(separator: "\n").map { Int($0)! }
    }

    private func next(_ x: Int) -> Int {
        var x = x
        x = prune(mix(x, x * 64))
        x = prune(mix(x, x / 32))
        x = prune(mix(x, x * 2048))
        return x
    }

    private func prune(_ x: Int) -> Int {
        x % 16_777_216
    }

    private func mix(_ x: Int, _ y: Int) -> Int {
        x ^ y
    }

    func part1() -> Int {
        let ints = self.parse(self.data)
        let result =
            ints
            .map { int in
                var x = int
                for _ in 0..<2000 {
                    x = next(x)
                }
                return x
            }
            .reduce(0, +)
        return result
    }

    func part2() -> Int {
        0
    }
}
