json.array!(@meet_mes) do |meet_me|
  json.extract! meet_me, :id, :address_1, :address_2, :term, :results
  json.url meet_me_url(meet_me, format: :json)
end
