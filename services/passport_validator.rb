class PassportValidator
    def initialize(strict: false)
        @strict = strict
    end

    def call(passport)
        fields_present?(passport) && (!@strict || fields_valid?(passport))
    end

    private

    def fields_present?(passport)
        %w(byr iyr eyr hgt hcl ecl pid).all? do |key|
            passport.has_key? key
        end
    end

    def fields_valid?(passport)
        birth_year_valid?(passport['byr']) &&
        issue_year_valid?(passport['iyr']) &&
        expiration_year_valid?(passport['eyr']) &&
        height_valid?(passport['hgt']) &&
        hair_colour_valid?(passport['hcl']) &&
        eye_colour_valid?(passport['ecl']) &&
        passport_id_valid?(passport['pid'])
    end

    def birth_year_valid?(year)
        /^\d{4}$/.match?(year) && (1920..2002).cover?(year.to_i)
    end

    def issue_year_valid?(year)
        /^\d{4}$/.match?(year) && (2010..2020).cover?(year.to_i)
    end

    def expiration_year_valid?(year)
        /^\d{4}$/.match?(year) && (2020..2030).cover?(year.to_i)
    end

    def height_valid?(height)
        result = /^(\d+)(cm|in)$/.match(height)
        return false unless result

        value, unit = result[1].to_i, result[2]
        (unit == "cm" && (150..193).cover?(value)) || (unit == "in" && (59..76).cover?(value))
    end

    def hair_colour_valid?(colour)
        /^#[0-9a-f]{6}$/.match? colour
    end

    def eye_colour_valid?(colour)
        %w(amb blu brn gry grn hzl oth).include? colour
    end

    def passport_id_valid?(pid)
        /^\d{9}$/.match? pid
    end
end
