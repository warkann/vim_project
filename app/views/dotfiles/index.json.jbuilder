json.array!(@dotfiles) do |dotfile|
  json.extract! dotfile, :id, :title, :body
  json.url dotfile_url(dotfile, format: :json)
end
