class ValidMessageFinder
    def initialize(rules, part2: false)
        @rules = rules.map(&:strip).map do |line|
            line.split(": ")
        end.to_h
        
        @regexps = {}

        if part2
            @regexps["8"] = build_regexp("42") + "+"
            @regexps["11"] = "(?<self>" + build_regexp("42") + "\\g<self>?" + build_regexp("31") + ")"
        end

        @validity = Regexp.compile("^#{build_regexp("0")}$")
    end

    def call(candidates)
        candidates.map(&:strip).select { |line| @validity.match? line }
    end

    private

    def build_regexp(target)
        @regexps[target] ||= case @rules[target]
        when '"a"'
            "a"
        when '"b"'
            "b"
        else
            rule = @rules[target].split("|").map do |subrule|
                subrule.split(" ").map { |id| build_regexp(id) }.join("")
            end.join("|")
            "(#{rule})"
        end
    end
end