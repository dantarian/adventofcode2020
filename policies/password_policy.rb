class PasswordPolicy
    def initialize(policy)
        result = /^(\d+)-(\d+)\s+(.)$/.match(policy)
        @min, @max, @character = result[1].to_i, result[2].to_i, result[3]
    end

    def valid?(password)
        (@min..@max).cover?(password.chars.count { |c| c == @character })
    end
end