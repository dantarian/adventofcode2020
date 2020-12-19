class AllergenFinder
    Recipe = Struct.new(:ingredients, :allergens)

    def initialize(input)
        @recipes = input.map do |line|
            /(.*) \(contains (.*)\)/.match(line) do |m|
                Recipe.new(m[1].split(" "), m[2].split(", "))
            end
        end
        @known_allergens = {}
        @possible_allergens = {}
        @recipes.each do |recipe|
            recipe.allergens.each do |allergen|
                ingredients = recipe.ingredients - @known_allergens.keys
                if @possible_allergens.has_key? allergen
                    @possible_allergens[allergen] &= recipe.ingredients
                else
                    @possible_allergens[allergen] = recipe.ingredients
                end
                if @possible_allergens[allergen].size == 1
                    ingredient = @possible_allergens.delete(allergen).first
                    mark_allergen_as_known(ingredient, allergen)                    
                end
            end
        end
    end

    def call
        @known_allergens
    end

    private

    def mark_allergen_as_known(ingredient, allergen)
        @known_allergens[ingredient] = allergen
        @possible_allergens.each do |allergen2, ingredients|
            ingredients.delete(ingredient)
            if ingredients.size == 1
                new_ingredient = @possible_allergens.delete(allergen2).first
                mark_allergen_as_known(ingredients.first, allergen2)
            end
        end
    end
end