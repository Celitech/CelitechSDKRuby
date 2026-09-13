require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.destinations.list_destinations

puts response
