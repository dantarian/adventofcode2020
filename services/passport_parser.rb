class PassportParser
    def call(passport_string)
        passport_string.split.map do |field| 
            field.split(":")
        end.to_h
    end
end
