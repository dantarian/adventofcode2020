require_relative '../data_objects/tile.rb'

class TileReader
    def call(input)
        File.read(input)
            .split(/\n{2,}/)
            .map do |block|
                id_line, *pattern = block.split(/\n/).map(&:strip)
                id = /Tile (\d+):/.match(id_line)[1].to_i
                Tile.new(id, pattern)
            end
    end
end