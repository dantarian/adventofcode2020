class Tile
    attr_reader :id, :matches

    def initialize(id, pattern)
        @id = id
        @pattern = pattern
        @matches = {}
        @rotation = 0
        @flip_horizontal = false
        @flip_vertical = false
    end

    def top
        @top ||= @pattern.first
    end

    def bottom
        @bottom ||= @pattern.last
    end

    def current_bottom
        chars = @pattern.map(&:chars)
        rotated = case @rotation
        when 0
            chars
        when 90
            chars.transpose.map(&:reverse)
        when 180
            chars.reverse.map(&:reverse)
        when 270
            chars.map(&:reverse).transpose
        end
        flipped = @flip_horizontal ? rotated.map(&:reverse) : rotated
        flipped = @flip_vertical ? flipped.reverse : flipped
        flipped.last.join("")
    end

    def left
        @left ||= @pattern.map(&:chars).map(&:first).join("")
    end

    def right
        @last_column ||= @pattern.map(&:chars).map(&:last).join("")
    end

    def current_right
        chars = @pattern.map(&:chars)
        rotated = case @rotation
        when 0
            chars
        when 90
            chars.transpose.map(&:reverse)
        when 180
            chars.reverse.map(&:reverse)
        when 270
            chars.map(&:reverse).transpose
        end
        flipped = @flip_horizontal ? rotated.map(&:reverse) : rotated
        flipped = @flip_vertical ? flipped.reverse : flipped
        flipped.map(&:last).join("")
    end

    def borders
        @borders ||= {top: self.top, bottom: self.bottom, left: self.left, right: self.right}
    end

    def add_match(border, tile_id)
        @matches[border] = tile_id
    end

    def rotate(degrees)
        @rotation = degrees
    end

    def flip_horizontal
        @flip_horizontal = !@flip_horizontal
    end

    def flip_vertical
        @flip_vertical = !@flip_vertical
    end

    def right_tile_id
        case @rotation
        when 0
            @flip_horizontal ? @matches[:left] : @matches[:right]
        when 90
            @flip_horizontal ? @matches[:bottom] : @matches[:top]
        when 180
            @flip_horizontal ? @matches[:right] : @matches[:left]
        when 270
            @flip_horizontal ? @matches[:top] : @matches[:bottom]
        end
    end

    def bottom_tile_id
        case @rotation
        when 0
            @flip_vertical ? @matches[:top] : @matches[:bottom]
        when 90
            @flip_vertical ? @matches[:left] : @matches[:right]
        when 180
            @flip_vertical ? @matches[:bottom] : @matches[:top]
        when 270
            @flip_vertical ? @matches[:right] : @matches[:left]
        end
    end

    def untrimmed_image_piece
        untrimmed = @pattern.map(&:chars)
        rotated = case @rotation
        when 0
            untrimmed
        when 90
            untrimmed.transpose.map(&:reverse)
        when 180
            untrimmed.reverse.map(&:reverse)
        when 270
            untrimmed.map(&:reverse).transpose
        end
        flipped = @flip_horizontal ? rotated.map(&:reverse) : rotated
        flipped = @flip_vertical ? flipped.reverse : flipped
        flipped.map { |arr| arr.join("") }
    end

    def image_piece
        trimmed = @pattern[1...@pattern.size - 1].map { |line| line.chars[1...line.size - 1] }
        rotated = case @rotation
        when 0
            trimmed
        when 90
            trimmed.transpose.map(&:reverse)
        when 180
            trimmed.reverse.map(&:reverse)
        when 270
            trimmed.map(&:reverse).transpose
        end
        flipped = @flip_horizontal ? rotated.map(&:reverse) : rotated
        flipped = @flip_vertical ? flipped.reverse : flipped
        flipped.map { |arr| arr.join("") }
    end

    def to_s
        "Id: #{@id} Rot: #{@rotation} Flip: #{@flip_horizontal ? 'X' : ''}#{@flip_vertical ? 'Y' : ''} Matches: #{@matches} Right: #{self.right_tile_id} Bottom: #{self.bottom_tile_id}"
    end
end
