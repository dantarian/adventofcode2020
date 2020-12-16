class TicketProcessor
    Field = Struct.new(:name, :lower_range, :upper_range) do
        def valid?(value)
            lower_range.cover?(value) || upper_range.cover?(value)
        end
    end

    def initialize(fields, other_tickets)
        validator = TicketValidator.new(fields)
        @other_tickets = other_tickets.map { |line| line.split(",").map(&:to_i) }
                                      .select { |ticket| validator.valid?(ticket) }
        @fields = fields.map do |line|
            /([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/.match(line) do |m|
                Field.new(m[1], (m[2].to_i .. m[3].to_i), (m[4].to_i .. m[5].to_i))
            end
        end

        possible_indices = @fields.map {|field| [field.name, (0...@fields.size).to_a]}.to_h
        possible_fields = (0...@fields.size).map { |i| [i, @fields.map(&:name)]}.to_h
        @known_indices = {}

        @other_tickets.each do |ticket|
            ticket.each.with_index do |value, index|
                @fields.each do |field|
                    unless field.valid?(value)
                        possible_indices[field.name].delete(index)
                        possible_fields[index].delete(field.name)
                    end
                end
            end
        end 


        until possible_indices.values.empty? and possible_fields.values.empty?
            possible_index = possible_indices.select { |_, array| array.size == 1 }.first
            if possible_index && possible_index.last.size == 1 
                name = possible_index.first
                indices = possible_index.last
                @known_indices[name] = indices.first
                possible_indices.delete(name)
                possible_indices.each_value { |v| v.delete(indices.first)}
                possible_fields.delete(indices.first)
                possible_fields.each_value { |v| v.delete(name)}
            end
            possible_field = possible_fields.select { |_, array| array.size == 1 }.first
            if possible_field && possible_field.last.size == 1
                index = possible_field.first
                names = possible_field.last
                @known_indices[names.first] = index
                possible_indices.delete(names.first)
                possible_indices.each_value { |v| v.delete(index)}
                possible_fields.delete(index)
                possible_fields.each_value { |v| v.delete(names.first)}
            end
        end
    end

    def call(ticket)
        ticket = ticket.first.split(",").map(&:to_i)
        @fields.filter { |field| field.name.start_with?("departure") }
               .map { |field| ticket[@known_indices[field.name]] }
               .inject(1) { |acc, val| acc * val }
    end
end