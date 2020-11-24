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
end

AOC.start(ARGV)
