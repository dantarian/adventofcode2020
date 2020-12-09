class NumberSetFinder
    Candidate = Struct.new(:min, :max, :sum) do
        def push(value)
            self.min = [self.min, value].min
            self.max = [self.max, value].max
            self.sum += value
        end    
    end

    def initialize(values)
        @values = values
    end

    def call(target)
        candidates = []
        @values.each do |value| 
            candidates.each do |candidate|
                candidate.push(value)
                return candidate.min + candidate.max if candidate.sum == target
            end
            
            candidates.filter! { |candidate| candidate.sum < target }
            candidates.push(Candidate.new(value, value, value))
        end
    end
end