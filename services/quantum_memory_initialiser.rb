class QuantumMemoryInitialiser
    def initialize(input)
        @memory = {}
        or_mask = 0
        neutralizer = 0
        variant_masks = []
        input.each do |line|
            /mask = ([10X]+)/.match(line) do |m|
                base_mask = m[1]
                # We want a mask that will set all X bits to 0, but preserve other values
                neutralizer = base_mask.gsub("0", "1").gsub("X", "0").to_i(2)
                variant_mask_base = base_mask.gsub("1", "0")
                x_bit_count = base_mask.count("X")
                variant_masks = (0...2**x_bit_count).map do |val|
                    # These should be zero except where we want to modify values.
                    mask = variant_mask_base
                    (x_bit_count - 1).downto(0) do |i|
                        mask = mask.sub("X", val[i].to_s)
                    end
                    mask.to_i(2)
                end
                or_mask = base_mask.gsub("X", "0").to_i(2)
            end
            /mem\[(\d+)\] = (\d+)/.match(line) do |m|
                base_addr = m[1].to_i & neutralizer | or_mask
                value = m[2].to_i
                variant_masks.each do |mask|
                    @memory[base_addr | mask] = value
                end
            end
        end
    end

    def call
        @memory.values.sum
    end
end