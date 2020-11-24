require_relative "./code_runner.rb"

class CodeFuzzer
    def initialize(program)
        @program = program
    end

    def call
        result = 0
        index = 0
        @program.any? do |line|
            state = :failure
            case line[0..2]
            when "nop"
                updated_program = Marshal.load(Marshal.dump(@program))
                updated_program[index] = line.sub("nop", "jmp")
                state, result = CodeRunner.new(updated_program).call
            when "jmp"
                updated_program = Marshal.load(Marshal.dump(@program))
                updated_program[index] = line.sub("jmp", "nop")
                state, result = CodeRunner.new(updated_program).call
            end
            index += 1
            state == :ok
        end
        result
    end
end