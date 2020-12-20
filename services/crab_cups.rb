class CrabCups
    Cup = Struct.new(:label, :next)

    def initialize(initial_state)
        @ring = {}
        previous = nil
        initial_state.each do |label|
            # Shift everything down to start at 0 - we'll shift back up on output.
            cup = Cup.new(label - 1, nil)
            previous.next = cup unless previous.nil?
            previous = @ring[label - 1] = cup
        end
        @current = previous.next = @ring[initial_state.first - 1]
    end

    def call(turns, output_type: :nine_lables)
        turns.times { take_turn }
        case output_type
        when :nine_labels
            output = ""
            cup = @ring[0].next
            while cup.label != 0
                output += "#{cup.label + 1}"
                cup = cup.next
            end
            output
        when :next_two_multiplied
            (@ring[0].next.label + 1) * (@ring[0].next.next.label + 1)
        else
            "Unknown output type."
        end
    end

    def take_turn
        taken_cups = [@current.next, @current.next.next, @current.next.next.next]
        @current.next = @current.next.next.next.next
        target_cup = (@current.label - 1) % @ring.size
        target_cup = (target_cup - 1) % @ring.size while taken_cups.map(&:label).include? target_cup
        destination = @ring[target_cup]
        taken_cups.last.next = destination.next
        destination.next = taken_cups.first
        @current = @current.next
    end
end
