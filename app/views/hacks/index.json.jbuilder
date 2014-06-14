json.array!(@hacks) do |hack|
  json.extract! hack, :id, :title, :body
  json.url hack_url(hack, format: :json)
end
