json.array!(@colorschemas) do |colorschema|
  json.extract! colorschema, :id, :title, :body
  json.url colorschema_url(colorschema, format: :json)
end
