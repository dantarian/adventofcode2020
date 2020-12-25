class HexTileFlipper
    def initialize(input)
        @tiles = input.map do |line|
            x, y = 0, 0
            while move = line.slice!(/(nw|ne|w|e|sw|se)/)
                case move
                when 'e'
                    x += 1
                when 'w'
                    x -= 1
                when 'ne'
                    x += y % 2
                    y -= 1
                when 'nw'
                    x -= 1 - (y % 2)
                    y -= 1
                when 'se'
                    x += y % 2
                    y += 1
                when 'sw'
                    x -= 1 - (y % 2)
                    y += 1
                end
            end
            [x, y] 
        end
    end

    def call
        @tiles.tally.select { |_,v| v % 2 == 1 }.keys
    end
end
