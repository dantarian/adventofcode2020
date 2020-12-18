require 'set'

class MonsterFinder
    def initialize(image)
        @image = image
        @monster1 = /..................#./
        @monster2 = /#....##....##....###/
        @monster3 = /.#..#..#..#..#..#.../
    end

    def call
        monsters = Set[]
        image = @image
        rotations = 0
        while monsters.empty?
            y = 0
            image.each_cons(3) do |line1, line2, line3|
                start_index = 0
                index = line2.index(@monster2, start_index)
                while index
                    if (index == line1.index(@monster1, index)) && (index == line3.index(@monster3, index))
                        monsters |= monster_squares(index, y)
                    end
                    start_index += 1
                    index = line2.index(@monster2, start_index)
                end
                y += 1
            end
            rotations += 1
            image = rotate(image)
            image = flip(image) if rotations == 4
        end
        monsters
    end

    private

    def monster_squares(x_start, y_start)
        [
            # Top row
            [x_start + 18, y_start],

            # Second row
            [x_start, y_start + 1], 
            [x_start + 5, y_start + 1], 
            [x_start + 6, y_start + 1],
            [x_start + 11, y_start + 1],
            [x_start + 12, y_start + 1],
            [x_start + 17, y_start + 1],
            [x_start + 18, y_start + 1],
            [x_start + 19, y_start + 1],

            # Third row
            [x_start + 1, y_start + 2],
            [x_start + 4, y_start + 2],
            [x_start + 7, y_start + 2],
            [x_start + 10, y_start + 2],
            [x_start + 13, y_start + 2],
            [x_start + 16, y_start + 2]
        ]
    end

    def rotate(image)
        image.map(&:chars).transpose.map(&:reverse).map { |row| row.join("") }
    end

    def flip(image)
        image.reverse
    end
end