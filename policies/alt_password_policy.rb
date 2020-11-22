class AltPasswordPolicy
    def initialize(policy)
        result = /^(\d+)-(\d+)\s+(.)$/.match(policy)
        @first, @second, @character = result[1].to_i, result[2].to_i, result[3]
    end

    def valid?(password)
        (password[@first-1] == @character) ^ (password[@second-1] == @character)
    end
end