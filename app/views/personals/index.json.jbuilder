json.array!(@personals) do |personal|
  json.extract! personal, :id, :name
  json.url personal_url(personal, format: :json)
end
