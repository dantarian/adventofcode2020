class Navigator
    Command = Struct.new(:action, :value)

    def initialize(input)
        @x = 0
        @y = 0
        @heading = 90
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
        @y += value
    end

    def south(value)
        @y -= value
    end

    def east(value)
        @x += value
    end

    def west(value)
        @x -= value
    end

    def left(value)
        @heading = (@heading - value) % 360
    end
    
    def right(value)
        @heading = (@heading + value) % 360
    end

    def forward(value)
        case @heading
        when 0
            north(value)
        when 90
            east(value)
        when 180
            south(value)
        when 270
            west(value)
        end
    end
end