class ScheduleSyncer
    Bus = Struct.new(:id, :offset)

    def initialize(input)
        @buses = input.strip
                      .split(",")
                      .each_with_index
                      .reject {|a,b| a == 'x' }
                      .map { |a,b| Bus.new(a.to_i, b) }
    end

    def call
        position = 0
        period = 1
        @buses.each do |bus|
            until (position + bus.offset) % bus.id == 0
                position += period
            end
            period *= bus.id
        end
        position
    end
end