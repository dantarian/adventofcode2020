class AdvancedCalculator
    def initialize(input)
        @calculations = input.map do |line|
            line.strip.gsub(' ', '').chars.map { |c| /\d/.match?(c) ? c.to_i : c }
        end
    end

    def call
        @calculations.map { |expression| calculate(expression) }.sum
    end

    private

    def calculate(expression)
        unless expression.include?("(")
            return calculate_simple_expression(expression)
        end

        first_bracket = expression.find_index("(")
        bracket_level = 1
        index = first_bracket
        while bracket_level > 0
            index += 1
            bracket_level += 1 if expression[index] == "("
            bracket_level -= 1 if expression[index] == ")"
        end
        matching_bracket = index

        calculate (expression[0 ... first_bracket] || []) + 
                  [calculate(expression.slice(first_bracket+1 ... matching_bracket))] +
                  (expression[index+1 ... expression.size] || [])
    end

    def calculate_simple_expression(expression)
        unless expression.include?("+")
            return expression.reject{ |c| c == "*"}
                             .inject(1) { |acc, val| acc *= val } 
        end

        first_plus = expression.find_index("+")

        calculate_simple_expression(
            (expression[0 ... first_plus-1] || []) +
            [expression[first_plus - 1] + expression[first_plus + 1]] +
            (expression[first_plus+2 ... expression.size])
        )
    end
end