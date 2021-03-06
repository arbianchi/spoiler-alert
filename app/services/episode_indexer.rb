class EpisodeIndexer

  #service object that adds episodes of a given show
  def initialize show
    @show = show
  end

  #adds episodes when a show is confirmed (at show creation)
  def index

    #API call to tvmaze
    resp = HTTParty.get "http://api.tvmaze.com/shows/#{@show.tvrage_id}/episodes"

    #add each episode to db
    resp.each do |e|
      add_episode e
    end
  end

  #only adds shows not currently in the db (mostly for new episodes when they are announced)
  def update

    #API call to tvmaze
    resp = HTTParty.get "http://api.tvmaze.com/shows/#{@show.tvrage_id}/episodes"

    #add new episodes to db
    resp.each do |e|
      unless @show.episodes.find_by(tvrage_e_id: e["id"]).present?
        add_episode e
      end
    end
  end

  private

  #method that actually adds the episodes to the db
  def add_episode e
    #specials are not currently searched for in tvmaze (but this would deal with them if they were)
    if e["number"].present?
      episode_number = e["number"]
    else
      episode_number = "special"
    end

    #only adds episodes that have an announced air_date
    if e["airstamp"]
      epi = @show.episodes.new(
                        title: e["name"],
                        air_date: e["airstamp"],
                        runtime: e["runtime"],
                        season: e["season"],
                        episode_number: episode_number,
                        tvrage_e_id: e["id"],
                        end_time: e["airstamp"] + e["runtime"].to_i.minutes
                        )
      epi.save!

      #queues up creation of a live feed for upcoming episodes (to be created an hour and 20 min before the airtime)
      if epi.air_date > Time.now
        LiveFeedWorker.perform_at(
                                (epi.air_date - (1.hours + 20.minutes)),
                                epi.id
                                )
      end
    end
  end
end
