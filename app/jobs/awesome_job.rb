class AwesomeJob < ApplicationJob
  queue_as :default

  thread = Thread.new do
  	loop do
		MQTT::Client.connect('mqtt://labict.be:1883') do |c|
		  # If you pass a block to the get method, then it will loop
		  c.get('iot/thijs/temp') do |topic,message|
		  	# object = JSON.parse("#{message}")
		  	# puts object
		  	temp = "#{message}"
		    puts "#{topic}: #{message}"
		    Measurement.create(temperature: temp.to_i)
		  end
		end
	 end
  end
end
