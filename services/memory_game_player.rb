class MemoryGamePlayer
    def initialize(input)
        @most_recently_seen = input.split(",").each.with_index.map do |val, i| 
            @last_value = val.to_i
            @current_turn = i + 1
            [@last_value, @current_turn]
        end.to_h
        @previously_seen = Hash.new
    end

    def call(turns)
        last_value, current_turn = @last_value, @current_turn
        while current_turn < turns
            if @previously_seen.has_key? last_value
                current_value = @most_recently_seen[last_value] - @previously_seen[last_value]
            else
                current_value = 0
            end
            current_turn += 1
            if @most_recently_seen.has_key? current_value
                @previously_seen[current_value] = @most_recently_seen[current_value]
            end
            @most_recently_seen[current_value] = current_turn
            last_value = current_value
        end
        current_value
    end
end