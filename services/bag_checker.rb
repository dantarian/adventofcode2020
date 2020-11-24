class BagChecker
    def initialize(rules)
        @rules = rules.map do |rule|
            description, contents_string = rule.split(" bags contain ")
            if contents_string.include? "no other bags"
                contents = Hash.new
            else
                contents = contents_string.split(", ").map do |bag|
                    results = /(\d+) (\w+ \w+) bag/.match(bag)
                    [ results[2], results[1].to_i ]
                end.to_h
            end
            [ description, contents ]
        end.to_h
    end

    def call(description, inwards: false)
        known_bags = Hash.new
        if inwards
            count_contents(known_bags, description) - 1
        else
            @rules.each do |bag, _|
                known_bags[bag] = check_bag(known_bags, bag, description)
            end
            known_bags.select { |_, contains_search_term| contains_search_term }.size
        end
    end

    def check_bag(known_bags, bag, description)
        contents = @rules[bag]
        return false if bag == description
        return false if contents.empty?
        return true if contents.has_key? description
        return true if contents.any? { |b, _| known_bags[b] }
        return false if contents.all? { |b, _| known_bags[b] == false }
        
        contents.any? { |b, _| check_bag(known_bags, b, description)}
    end

    def count_contents(known_bags, description)
        return known_bags[description] if known_bags.has_key? description

        contents = @rules[description]

        if contents.empty?
            return known_bags[description] = 1
        end

        known_bags[description] = contents.inject(1) do |acc, (desc, count)|
            acc + (count * count_contents(known_bags, desc))
        end
    end
end