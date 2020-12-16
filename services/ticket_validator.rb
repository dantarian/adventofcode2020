class TicketValidator
    def initialize(fields)
        @ranges = fields.map do |line|
            /[a-z]+: (\d+)-(\d+) or (\d+)-(\d+)/.match(line) do |m|
                [(m[1].to_i .. m[2].to_i), (m[3].to_i .. m[4].to_i)]
            end
        end.flatten
    end

    def valid?(ticket)
        ticket.all? { |val| @ranges.any? { |range| range.cover? val } }
    end
end