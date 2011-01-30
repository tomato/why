RSpec.configure do |c|
 c.after do |m|
   Rails.logger.debug "=== ^^ #{m.example.full_description} ^^ ==="
   Rails.logger.debug "=== ^^ #{m.example.location} ^^ ==="
 end
end

