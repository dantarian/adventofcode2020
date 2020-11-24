class CodeRunner
    Command = Struct.new(:instruction, :parameter, :call_count)

    def initialize(program)
        @program = program.map do |line|
            instruction, parameter = line.split(" ")
            Command.new(instruction, parameter.to_i, 0)
        end
    end

    def call
        ptr = 0
        acc = 0
        while ptr < @program.size && @program[ptr].call_count == 0
            @program[ptr].call_count += 1
            case @program[ptr].instruction
            when "acc"
                acc += @program[ptr].parameter
                ptr += 1
            when "nop"
                ptr += 1
            when "jmp"
                ptr += @program[ptr].parameter
            end
        end
        [ptr == @program.size ? :ok : :failure, acc]
    end
end