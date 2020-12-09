class InvalidCodeFinder
    def initialize(window:, values:)
        @values = values
        @window = window
    end

    def call
        sums = Hash.new
        @values.take(@window).each_with_index do |val, index|
            sums[val] = @values[index+1,@window - (index + 1)].map { |val2| val + val2 }
        end
        @values.each_cons(@window + 1) do |window|
            return window.last if sums.values.none? { |a| a.include? window.last }
            sums.delete(window.first)
            window[1, @window].each do |val|
                if sums.has_key?(val)
                    sums[val].push(val + window.last)
                else
                    sums[val] = [val + window.last] unless val == window.last
                end
            end
        end
    end
end