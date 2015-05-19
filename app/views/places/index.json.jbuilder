json.array!(@places) do |place|
  json.extract! place, :id, :personal_id, :name, :address, :latitude, :longitude
  json.url place_url(place, format: :json)
end
