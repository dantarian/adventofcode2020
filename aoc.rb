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
end

AOC.start(ARGV)
