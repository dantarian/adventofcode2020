class MemoryInitialiser
    def initialize(input)
        @memory = {}
        and_mask = 0
        or_mask = 0
        input.each do |line|
            /mask = ([10X]+)/.match(line) do |m|
                or_mask = m[1].gsub("X", "0").to_i(2)
                and_mask = m[1].gsub("X", "1").to_i(2)
            end
            /mem\[(\d+)\] = (\d+)/.match(line) do |m|
                @memory[m[1].to_i] = m[2].to_i & and_mask | or_mask
            end
        end
    end

    def call
        @memory.values.sum
    end
end