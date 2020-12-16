class Calculator
    def initialize(input)
        @calculations = input.map do |line|
            line.strip.gsub(' ', '').chars
        end
    end

    def call
        @calculations.map { |expression| calculate(expression) }.sum
    end

    private

    def calculate(chars)
        remaining_chars = chars
        result = 0
        operator = nil
        while remaining_chars.size > 0
            current_char, *remaining_chars = remaining_chars
            case current_char
            when ')'
                return [result, remaining_chars]
            when '+'
                operator = :add
            when '*'
                operator = :multiply
            when /\d/
                result = operate(result, operator, current_char.to_i)
            when '('
                value, remaining_chars = calculate(remaining_chars)
                result = operate(result, operator, value)
            end
        end
        result
    end

    def operate(base, operator, value)
        case operator
        when :add
            base + value
        when :multiply
            base * value
        else
            value
        end
    end
end