class CrabCombat
    def call(deck1, deck2)
        until deck1.empty? || deck2.empty?
            card1 = deck1.shift
            card2 = deck2.shift
            if card2 > card1
                deck2 << card2 << card1
            else
                deck1 << card1 << card2
            end
        end

        if deck1.empty?
            score(deck2)
        else
            score(deck1)
        end
    end

    def score(deck)
        deck.reverse.each.with_index.inject(0) { |acc, (card, i)| acc += card * (i+1) }
    end
end