class SeatFinder
    Point = Struct.new(:x, :y)

    def initialize(input, consecutive: true)
        @occupied = input.map do |line|
            line.strip.chars.map do |c|
                case c
                when 'L'
                    false
                when '#' 
                    true
                else 
                    nil
                end
            end
        end

        directions = [
            Point.new(-1,-1), Point.new(0,-1), Point.new(1, -1),
            Point.new(-1, 0),                  Point.new(1, 0),
            Point.new(-1, 1), Point.new(0, 1), Point.new(1, 1)
        ]
        
        @valid_x = (0...@occupied.first.size)
        @valid_y = (0...@occupied.size)

        @neighbours = @occupied.each_with_index.map do |row, y|
            row.each_with_index.map do |location, x|
                directions.filter_map do |direction|
                    if consecutive
                        candidate = Point.new(x + direction.x, y + direction.y)
                        candidate if valid?(candidate) && !@occupied[candidate.y][candidate.x].nil?
                    else
                        find_first_seat(@occupied, x, y, direction)
                    end
                end
            end
        end
    end

    def call(limit = 4)
        changed = true
        occupied = @occupied
        while changed
            changed = false
            occupied = occupied.each_with_index.map do |row, y|
                row.each_with_index.map do |seat_occupied, x|
                    case
                    when seat_occupied.nil?
                        nil
                    when seat_occupied && (@neighbours[y][x].count { |loc| occupied[loc.y][loc.x] } >= limit)
                        changed = true
                        false
                    when !seat_occupied && !@neighbours[y][x].any? { |loc| occupied[loc.y][loc.x] }
                        changed = true
                        true
                    else
                        seat_occupied
                    end
                end
            end
        end
        occupied.flatten.count(true)
    end

    private

    def valid?(point)
        @valid_x.cover?(point.x) && @valid_y.cover?(point.y)
    end

    def find_first_seat(seats, start_x, start_y, direction)
        x = start_x + direction.x
        y = start_y + direction.y
        location = Point.new(x, y)
        until !valid?(location)
            return location unless seats[location.y][location.x].nil?
            location = Point.new(location.x + direction.x, location.y + direction.y)
        end

        nil
    end
end