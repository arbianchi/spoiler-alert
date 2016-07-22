json.options @shows do |show|
  json.tvrage_id      show.tvrage_id
  json.title          show.title.split.map(&:capitalize).join(' ')
  json.summary        show.summary
  json.cover_img_url  show.cover_img_url
end
