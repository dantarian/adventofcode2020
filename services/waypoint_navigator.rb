class WaypointNavigator
    Command = Struct.new(:action, :value)

    def initialize(input)
        @x = 0
        @y = 0
        @waypoint_x = 10
        @waypoint_y = 1
        actions = {
            'N' => :north,
            'S' => :south,
            'E' => :east,
            'W' => :west,
            'L' => :left,
            'R' => :right,
            'F' => :forward
        }
    
        @route = input.map(&:strip).map do |entry|
            /(N|S|E|W|L|R|F)(\d+)/.match(entry) do |m|
                Command.new(actions[m[1]], m[2].to_i)
            end
        end
    end

    def call
        @route.each do |command|
            send(command.action, command.value)
        end
        @x.abs + @y.abs
    end

    def north(value)
        @waypoint_y += value
    end

    def south(value)
        @waypoint_y -= value
    end

    def east(value)
        @waypoint_x += value
    end

    def west(value)
        @waypoint_x -= value
    end

    def left(value)
        rotate_waypoint(-value) 
    end
    
    def right(value)
        rotate_waypoint(value)
    end

    def rotate_waypoint(value)
        case value % 360
        when 90
            @waypoint_x, @waypoint_y = @waypoint_y, -@waypoint_x
        when 180
            @waypoint_x, @waypoint_y = -@waypoint_x, -@waypoint_y
        when 270
            @waypoint_x, @waypoint_y = -@waypoint_y, @waypoint_x
        end
    end

    def forward(value)
        @x = @x + (@waypoint_x * value)
        @y = @y + (@waypoint_y * value)
    end
end