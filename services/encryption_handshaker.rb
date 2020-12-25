class EncryptionHandshaker
    def call(loop_size, public_key)
        value = 1
        loop_size.times do
            value = (value * public_key) % 20201227
        end
        value
    end
end
