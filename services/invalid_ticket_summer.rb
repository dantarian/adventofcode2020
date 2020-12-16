class InvalidTicketSummer
    def initialize(fields)
        @ranges = fields.map do |line|
            /[a-z]+: (\d+)-(\d+) or (\d+)-(\d+)/.match(line) do |m|
                [(m[1].to_i .. m[2].to_i), (m[3].to_i .. m[4].to_i)]
            end
        end.flatten
    end

    def call(tickets)
        tickets.map { |line| line.split(",").map(&:to_i) }
               .flatten
               .filter { |val| @ranges.none? {|range| range.cover? val }}
               .sum
    end
end