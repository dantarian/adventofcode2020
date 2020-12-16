require 'set'

class GameOfLife
    Point3 = Struct.new(:x, :y, :z) do
        def initialize(x, y, z = 0); super end

        def neighbours
            @neighbours ||=
                (-1..1).flat_map do |delta_x|
                    (-1..1).flat_map do |delta_y|
                        (-1..1).filter_map do |delta_z|
                            unless delta_x == 0 && delta_y == 0 && delta_z == 0
                               Point3.new(x + delta_x, y + delta_y, z + delta_z)
                            end
                        end
                    end
                end
        end
    end

    Point4 = Struct.new(:x, :y, :z, :w) do
        def initialize(x, y, z = 0, w = 0); super end

        def neighbours
            @neighbours ||=
                (-1..1).flat_map do |delta_x|
                    (-1..1).flat_map do |delta_y|
                        (-1..1).flat_map do |delta_z|
                            (-1..1).filter_map do |delta_w|
                                unless delta_x == 0 && delta_y == 0 && delta_z == 0 && delta_w == 0
                                    Point4.new(x + delta_x, y + delta_y, z + delta_z, w + delta_w)
                                end
                            end
                        end
                    end
                end
        end
    end

    def initialize(input, dimensions: 3)
        @state = []
        point = dimensions == 4 ? Point4 : Point3
        input.map(&:strip).each.with_index do |line, y|
            line.chars.each.with_index do |c, x|
                @state << point.new(x, y, 0) if c == "#"
            end
        end
    end

    def call(turns)
        turns.times do
            take_turn
        end
        @state.size
    end

    def take_turn
        locations_to_check = @state.flat_map(&:neighbours).to_set
        new_state = locations_to_check.to_a.select do |point|
            if active?(point)
                active_neighbour_count?(point, min: 2, max: 3)
            else
                active_neighbour_count?(point, min: 3, max: 3)
            end
        end
        @state = new_state.to_set
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