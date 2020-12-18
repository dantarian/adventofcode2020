class ImageBuilder
    def initialize(tiles, corners)
        @tiles = tiles
        @corners = corners
    end

    def call
        placed_tiles = []
        current_tile = first_tile
        until current_tile.nil?
            current_row = [current_tile]
            until current_tile.right_tile_id.nil?
                previous_tile = current_tile
                current_tile = @tiles.select { |tile| tile.id == previous_tile.right_tile_id }.first
                manipulate_right(current_tile, previous_tile)
                current_row << current_tile
            end
            placed_tiles << current_row
            previous_tile = current_row.first
            if previous_tile.bottom_tile_id
                current_tile = @tiles.select { |tile| tile.id == previous_tile.bottom_tile_id }.first
                manipulate_bottom(current_tile, previous_tile)
            else
                current_tile = nil
            end
        end
        placed_tiles.map do |row| 
            row.map do |tile| 
                tile.image_piece
            end.transpose.map { |line| line.join("") }
        end.flatten
    end

    private

    def first_tile
        tile = @corners.first
        case
        when tile.matches.has_key?(:bottom) && tile.matches.has_key?(:right)
            # No rotation needed
        when tile.matches.has_key?(:top) && tile.matches.has_key?(:right)
            tile.rotate(90)
        when tile.matches.has_key?(:top) && tile.matches.has_key?(:left)
            tile.rotate(180)
        when tile.matches.has_key?(:bottom) && tile.matches.has_key?(:left)
            tile.rotate(270)
        else
            abort("Unexpected matches: #{tile.matches}")
        end
        tile
    end

    def manipulate_right(current_tile, previous_tile)
        case previous_tile.id
        when current_tile.matches[:left]
            current_tile.flip_vertical unless previous_tile.current_right == current_tile.left
        when current_tile.matches[:bottom]
            current_tile.rotate(90)
            current_tile.flip_vertical unless previous_tile.current_right == current_tile.bottom
        when current_tile.matches[:right]
            current_tile.rotate(180)
            current_tile.flip_vertical unless previous_tile.current_right == current_tile.right.reverse
        when current_tile.matches[:top]
            current_tile.rotate(270)
            current_tile.flip_vertical unless previous_tile.current_right == current_tile.top.reverse
        end
    end

    def manipulate_bottom(current_tile, previous_tile)
        case previous_tile.id
        when current_tile.matches[:top]
            current_tile.flip_horizontal unless previous_tile.current_bottom == current_tile.top
        when current_tile.matches[:left]
            current_tile.rotate(90)
            current_tile.flip_horizontal unless previous_tile.current_bottom == current_tile.left.reverse
        when current_tile.matches[:bottom]
            current_tile.rotate(180)
            current_tile.flip_horizontal unless previous_tile.current_bottom == current_tile.bottom.reverse
        when current_tile.matches[:right]
            current_tile.rotate(270)
            current_tile.flip_horizontal unless previous_tile.current_bottom == current_tile.right
        end
    end

end