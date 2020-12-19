require 'digest'

class RecursiveCombat
    def initialize
        @hasher = Digest::SHA256.new
        @known_outcomes = {}
    end

    def call(deck1, deck2)
        _, winning_deck = play(deck1, deck2)
        score(winning_deck)
    end

    def play(deck1, deck2)
        start_state = state(deck1, deck2)
        return @known_outcomes[start_state] if @known_outcomes.has_key? start_state

        previous_states = []
        winner = nil
        until winner
            current_state = state(deck1, deck2)
            if previous_states.include?(current_state)
                winner = 1
            else
                previous_states << current_state
                card1 = deck1.shift
                card2 = deck2.shift
                if deck1.size >= card1 && deck2.size >= card2
                    round_winner, _ = play(deck1.take(card1), deck2.take(card2))
                else
                    round_winner = (card1 > card2 ? 1 : 2)
                end

                if round_winner == 1
                    deck1 << card1 << card2
                else
                    deck2 << card2 << card1
                end

                winner = deck1.empty? ? 2 : deck2.empty? ? 1 : nil
            end
        end
        @known_outcomes[start_state] = [winner, winner == 1 ? deck1 : deck2]
    end

    def state(deck1, deck2)
        [deck1, deck2].hash
    end

    def score(deck)
        deck.reverse.each.with_index.inject(0) { |acc, (card, i)| acc += card * (i+1) }
    end
end