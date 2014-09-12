json.array!(@hacks) do |hack|
  json.extract! hack, :id
  json.url hack_url(hack, format: :json)
end
