class HexGameOfLife
    Point = Struct.new(:x, :y) do
        def neighbours
            @neighbours ||=
                [
                    Point.new(x - (1 - (y % 2)), y - 1), Point.new(x + (y % 2) , y - 1),
                    Point.new(x - 1, y), Point.new(x + 1, y),
                    Point.new(x - (1 - (y % 2)), y + 1), Point.new(x + (y % 2) , y + 1)
                ]
        end
    end

    def initialize(tiles)
        @state = tiles.map { |x, y| Point.new(x, y) }.uniq
    end

    def call(turns)
        turns.times do
            take_turn
        end
        @state.size
    end

    def take_turn
        locations_to_check = @state.flat_map(&:neighbours).uniq
        new_state = locations_to_check.select do |point|
            if active?(point)
                active_neighbour_count?(point, min: 1, max: 2)
            else
                active_neighbour_count?(point, min: 2, max: 2)
            end
        end
        @state = new_state.uniq
    end

    def active?(point)
        @state.include? point
    end

    def active_neighbour_count?(point, min:, max:)
        count = 0
        point.neighbours.each do |p2|
            count += 1 if active?(p2)
            return false if count > max
        end
        count >= min
    end        
end