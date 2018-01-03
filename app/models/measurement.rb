class Measurement < ApplicationRecord
	after_save :broadcast

    def broadcast
        ActionCable.server.broadcast "temperature", data: temperature
    end
end
