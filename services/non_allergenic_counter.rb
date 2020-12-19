class NonAllergenicCounter
    def initialize(input)
        @recipes = input.map do |line|
            /(.*) \(contains (.*)\)/.match(line) do |m|
                m[1].split(" ")
            end
        end
    end

    def call(allergenics)
        @recipes.map do |recipe| 
            recipe.reject do |ingredient| 
                allergenics.include? ingredient
            end.count
        end.sum
    end
end
