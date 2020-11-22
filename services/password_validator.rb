class PasswordValidator
    def initialize(policy)
        @policy = policy
    end

    def call(password)
        @policy.valid?(password)
    end
end