#!/usr/local/bin/ruby
# frozen_string_literal: true

require 'thor'
require './services/expenses_validator.rb'

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

end

AOC.start(ARGV)
