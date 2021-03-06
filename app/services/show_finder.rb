class ShowFinder

  #service object that searches for a show (by title/showname), saves the results to the db, and returns the results
  def initialize showname
    @showname = showname
  end

  #method that seaches/saves/returns
  def options
    shows = []

    #API call to tvmaze
    resp = HTTParty.get "http://api.tvmaze.com/search/shows?q=#{@showname}"

    #saves each responce to db, pushes into shows array
    resp.each do |s|

      if s["show"]["image"].present?
        img_url = s["show"]["image"]["original"]
      else
        img_url = 'https://s3.amazonaws.com/watch-party/uploads/fallback/image-not-found.png'
      end

      if s["show"]["network"].present?
        network = s["show"]["network"]["name"]
      else
        network = "Unknown"
      end

      option = Show.new(
              title:          s["show"]["name"],
              cover_img_url:  img_url,
              summary:        s["show"]["summary"],
              tvrage_id:      s["show"]["id"],
              network:        network
              )
      option.save
      shows.push option
    end
    return shows
  end

end
