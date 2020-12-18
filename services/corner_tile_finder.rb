class CornerTileFinder
    attr_reader :tiles
    
    def initialize(tiles)
        @tiles = tiles
    end

    def call
        @tiles.each.with_index do |tile, index|
            @tiles.slice(index+1 ... @tiles.size).each do |other_tile|
                tile.borders.each do |side, border|
                    other_tile.borders.select do |_, other_border|
                        [border, border.reverse].include?(other_border)
                    end.each_pair do |other_side, other_border|
                        tile.add_match(side, other_tile.id)
                        other_tile.add_match(other_side, tile.id)
                    end
                end
            end
        end
        @tiles.select { |tile| tile.matches.count == 2 }
    end
end