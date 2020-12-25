#!/usr/local/bin/ruby
# frozen_string_literal: true

require 'thor'
Dir.glob('./services/*.rb', &method(:require))
Dir.glob('./policies/*.rb', &method(:require))

class AOC < Thor
    class_option :part2, type: :boolean, aliases: "-2"

    no_commands {
        def self.exit_on_failure?
            true
        end
    }    

    desc "day1 INPUTFILE", "Expenses checker"

    def day1(input)
        abort("File not found!") unless File.exists?(input)
        validator = ExpensesValidator.new(options[:part2] ? :ternary : :binary)
        puts validator.call(File.readlines(input).map(&:to_i))
    end

    desc "day2 INPUTFILE", "Password validator"

    def day2(input)
        abort("File not found!") unless File.exists?(input)
        policyClass = options[:part2] ? AltPasswordPolicy : PasswordPolicy
        puts File.readlines(input)
            .map { |s| s.split(":").map(&:strip) }
            .count { |policy, password| PasswordValidator.new(policyClass.new(policy)).call(password) }
    end

    desc "day3 INPUTFILE", "Toboggan trajectory"

    def day3(input)
        abort("File not found!") unless File.exists?(input)
        treemap = File.readlines(input)
                      .map { |s| s.strip.chars.map { |c| c == '#' ? 1 : 0 } }
        counter = TreeCounter.new(treemap)
        
        if options[:part2]
            puts counter.call(right: 1, down: 1) *
                 counter.call(right: 3, down: 1) *
                 counter.call(right: 5, down: 1) *
                 counter.call(right: 7, down: 1) *
                 counter.call(right: 1, down: 2)
        else
            puts counter.call(right: 3, down: 1)
        end
    end

    desc "day4 INPUTFILE", "Passport validation"

    def day4(input)
        abort("File not found!") unless File.exists?(input)
        passports = File.read(input)
                        .split(/\n{2,}/)
                        .map { |passport| PassportParser.new.call(passport) }
        validator = PassportValidator.new(strict: options[:part2])
        puts passports.count { |passport| validator.call(passport) }
    end

    desc "day5 INPUTFILE", "Boarding cards"

    def day5(input)
        abort("File not found!") unless File.exists?(input)
        ids = File.readlines(input)
                 .map(&:strip)
                 .map { |s| s.gsub(/[FBLR]/, "F"=>"0", "L"=>"0", "B"=>"1", "R"=>"1") }
                 .map { |s| s.to_i(2) }
        if options[:part2]
            puts ids.sort
                    .each_slice(2)
                    .select { |a,b| b == a + 2 }
                    .first.first + 1
        else
            puts ids.max
        end
    end

    desc "day6 INPUTFILE", "Customs forms"

    def day6(input)
        abort("File not found!") unless File.exists?(input)
        declarations = File.read(input).split(/\n{2,}/)
        if options[:part2]
            puts declarations
                .map { |s| 
                    ('a'..'z').select { |c|
                        s.split(/\n/).all? { |l| l.include?(c) }
                    }.count
                }.sum
        else
            puts declarations
                    .map { |s| ('a'..'z').select { |c| s.include?(c) }.count }
                    .sum
        end
    end

    desc "day7 INPUTFILE", "Bag checker"

    def day7(input)
        abort("File not found!") unless File.exists?(input)
        puts BagChecker.new(File.readlines(input)).call("shiny gold", inwards: options[:part2])
    end

    desc "day8 INPUTFILE", "Handheld halting"

    def day8(input)
        abort("File not found!") unless File.exists?(input)
        if options[:part2]
            puts CodeFuzzer.new(File.readlines(input)).call()
        else
            puts CodeRunner.new(File.readlines(input)).call()[1]
        end
    end

    desc "day9 WINDOW INPUTFILE", "Encoding error"

    def day9(window_size, input)
        abort("Please specify a positive integer as the window.") unless window_size.to_i > 0
        abort("File not found!") unless File.exists?(input)
        values = File.readlines(input).map(&:strip).map(&:to_i)
        invalid_code =  InvalidCodeFinder.new(window: window_size.to_i, values: values).call
        if options[:part2]
            puts NumberSetFinder.new(values).call(invalid_code)
        else
            puts invalid_code
        end
    end

    desc "day10 INPUTFILE", "Adapter array"

    def day10(input)
        abort("File not found!") unless File.exists?(input)
        jolts = [0] + File.readlines(input).map(&:strip).map(&:to_i).sort
        jolts.push (jolts.max + 3)
        if options[:part2]
            paths = jolts.reverse.inject({}) do |acc, val|
                acc[val] = [(val+1 .. val+3).map { |i| acc[i] || 0 }.sum, 1].max
                acc
            end
            puts paths[0]
        else
            diffs = jolts.each_cons(2).map{ |a,b| b - a }.tally
            puts diffs[1] * diffs[3]
        end
    end

    desc "day11 INPUTFILE", "Seating system"

    def day11(input)
        abort("File not found!") unless File.exists?(input)
        if options[:part2]
            puts SeatFinder.new(File.readlines(input), consecutive: false).call(5)
        else
            puts SeatFinder.new(File.readlines(input)).call
        end
    end

    desc "day12 INPUTFILE", "Rain risk"

    def day12(input)
        abort("File not found!") unless File.exists?(input)
        if options[:part2]
            puts WaypointNavigator.new(File.readlines(input)).call
        else
            puts Navigator.new(File.readlines(input)).call
        end
    end

    desc "day13 INPUTFILE", "Shuttle search"

    def day13(input)
        abort("File not found!") unless File.exists?(input)
        line1, line2 = File.readlines(input)
        if options[:part2]
            puts ScheduleSyncer.new(line2).call
        else
            target_departure = line1.strip.to_i
            puts line2.strip
                      .split(",")
                      .reject { |str| str == "x" }
                      .map(&:to_i)
                      .map { |id| [id, id - (target_departure % id)] }
                      .min { |a,b| a.last <=> b.last }
                      .inject(1) { |acc, val| acc * val }
        end
    end

    desc "day14 INPUTFILE", "Docking data"

    def day14(input)
        abort("File not found!") unless File.exists?(input)
        if options[:part2]
            puts QuantumMemoryInitialiser.new(File.readlines(input)).call
        else
            puts MemoryInitialiser.new(File.readlines(input)).call
        end
    end

    desc "day15 INITIAL_STATE", "Rambunctious recitation"

    def day15(input)
        game = MemoryGamePlayer.new(input)
        if options[:part2]
            puts game.call(30000000)
        else
            puts game.call(2020)
        end
    end

    desc "day16 FIELDS YOUR_TICKET OTHER_TICKETS", "Ticket translation"

    def day16(fields, ticket, other_tickets)
        abort("File not found: #{fields}") unless File.exists?(fields)
        abort("File not found: #{ticket}") unless File.exists?(ticket)
        abort("File not found: #{other_tickets}") unless File.exists?(other_tickets)
        if options[:part2]
            puts TicketProcessor.new(File.readlines(fields), File.readlines(other_tickets)).call(File.readlines(ticket))
        else
            puts InvalidTicketSummer.new(File.readlines(fields)).call(File.readlines(other_tickets))
        end
    end

    desc "day17 INPUTFILE", "Conway cubes"

    def day17(input)
        abort("File not found!") unless File.exists?(input)
        if options[:part2]
            puts GameOfLife.new(File.readlines(input), dimensions: 4).call(6)
        else
            puts GameOfLife.new(File.readlines(input)).call(6)
        end
    end

    desc "day18 INPUTFILE", "Operation order"

    def day18(input)
        abort("File not found!") unless File.exists?(input)
        if options[:part2]
            puts AdvancedCalculator.new(File.readlines(input)).call
        else
            puts Calculator.new(File.readlines(input)).call
        end
    end

    desc "day19 RULES CANDIDATES", "Monster messages"

    def day19(rules, candidates)
        abort("File not found: #{rules}") unless File.exists?(rules)
        abort("File not found: #{candidates}") unless File.exists?(candidates)
        puts ValidMessageFinder
            .new(File.readlines(rules), part2: options[:part2])
            .call(File.readlines(candidates)).count
    end

    desc "day20 INPUTFILE", "Jurassic jigsaw"

    def day20(input)
        abort("File not found!") unless File.exists?(input)
        corner_finder = CornerTileFinder.new(TileReader.new.call(input))
        corners = corner_finder.call
        if options[:part2]
            matched_tiles = corner_finder.tiles
            image = ImageBuilder.new(matched_tiles, corners).call
            sea_monster_locations = MonsterFinder.new(image).call
            puts image.map { |str| str.count("#") }.sum - sea_monster_locations.size
        else
            puts corners.map(&:id).inject(1) { |acc, val| acc *= val }
        end
    end

    desc "day21 INPUTFILE", "Allergen assessment"

    def day21(input)
        abort("File not found!") unless File.exists?(input)
        recipes = File.readlines(input)
        allergenics = AllergenFinder.new(recipes).call
        if options[:part2]
            puts allergenics.to_a.sort { |a,b| a.last<=>b.last }.map(&:first).join(",")
        else
            puts NonAllergenicCounter.new(recipes).call(allergenics.keys)
        end
    end

    desc "day22 INPUTFILE", "Crab combat"

    def day22(input)
        abort("File not found!") unless File.exists?(input)
        deck1, deck2 = File.read(input).split(/\n{2,}/).map do |deck|
            _, *deck = deck.split(/\n/)
            deck.map(&:to_i)
        end
        if options[:part2]
            puts RecursiveCombat.new.call(deck1, deck2)
        else
            puts CrabCombat.new.call(deck1, deck2)
        end
    end

    desc "day23 INITIAL_STATE TURNS", "Crab cups"

    def day23(initial_state, turns)
        if options[:part2]
            state = initial_state.chars.map(&:to_i) + (initial_state.size + 1 .. 1_000_000).to_a
            puts CrabCups.new(state).call(turns.to_i, output_type: :next_two_multiplied)
        else
            puts CrabCups.new(initial_state.chars.map(&:to_i)).call(turns.to_i)
        end
    end

    desc "day24 INPUTFILE", "Lobby layout"

    def day24(input)
        abort("File not found!") unless File.exists?(input)
        tiles = HexTileFlipper.new(File.readlines(input)).call
        if options[:part2]
            puts HexGameOfLife.new(tiles).call(100)
        else
            puts tiles.count
        end
    end

    desc "day25 CARD_KEY DOOR_KEY", "Combo breaker"

    def day25(card_key, door_key)
        card_key = card_key.to_i
        door_key = door_key.to_i
        abort("Please supply two positive numbers.") unless card_key > 0 && door_key > 0
        card_loops, door_loops = LoopSizeFinder.new.call(card_key, door_key)
        puts EncryptionHandshaker.new.call(card_loops, door_key)
    end
end

AOC.start(ARGV)
