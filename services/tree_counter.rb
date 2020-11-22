class TreeCounter
    def initialize(treemap)
        @treemap = treemap
        @width = treemap[0].length
        @height = treemap.length
    end

    def call(right:, down:)
        x, y = right, down
        trees = 0
        while y < @height
            trees += tree(x, y)
            x += right
            y += down
        end
        trees
    end

    private

    def tree(x, y)
        @treemap[y][x % @width]
    end
end