json.array!(@reverse_locations) do |reverse_location|
  json.extract! reverse_location, :id, :address, :latitude, :longitude
  json.url reverse_location_url(reverse_location, format: :json)
end
