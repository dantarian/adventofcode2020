class LoopSizeFinder
    def call(card_key, door_key)
        card_loop_size = nil
        door_loop_size = nil
        loops = 0
        value = 1
        subject_number = 7
        while card_loop_size.nil? || door_loop_size.nil?
            loops += 1
            value = (value * subject_number) % 20201227
            card_loop_size = loops if card_loop_size.nil? && value == card_key
            door_loop_size = loops if door_loop_size.nil? && value == door_key
        end
        [card_loop_size, door_loop_size]
    end
end

