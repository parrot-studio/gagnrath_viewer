class ViewController < ApplicationController

  before_action do
    @gvdates = CacheData.result_dates
  end

  def index
    @guilds = CacheData.guild_result_for_all
    @rankers = CacheData.call_rankers_for_all
  end

  def about
  end

  def result
    @gvdate = params[:date]
    (render_404; return) unless @gvdates.include?(@gvdate)
    @guilds = CacheData.call_rankers_for(@gvdate)
    @rulers = CacheData.rulers_for(@gvdate)
  end

  def ranker
    @gvdate = params[:date]
    (render_404; return) unless @gvdates.include?(@gvdate)
    @guilds = CacheData.call_rankers_for(@gvdate)
  end

end
