class ExpensesValidator
    def initialize(mode = :binary)
        abort("Unknown mode") unless [:binary, :ternary].include? mode
        @ternary = (mode == :ternary)
    end

    def call(expenses)
        unless @ternary
            return self.binary(expenses.sort)
        end

        self.ternary(expenses.sort)
    end

    private

    def binary(expenses, target: 2020)
        low_index = 0

        expenses.reverse.each do |val|
            if val <= target
                low_index += 1 while expenses[low_index] + val < target
                return expenses[low_index] * val if expenses[low_index] + val == target
            end
        end

        0
    end

    def ternary(expenses)
        expenses.each do |val, index|
            if val >= 2020 / 3
                pairwise = self.binary(expenses[0...index], target: 2020 - val)
                return val * pairwise if pairwise != 0
            end
        end
    end
end
