module ViewHelper

  def each_rankers_for_view(guilds, max_rank = nil)
    return if guilds.blank?
    count = nil
    rank = 1
    guilds.sort_by(&:called_count).reverse.each.with_index(1) do |g, i|
      cc = g.called_count
      count ||= cc
      if count > cc
        rank = i
        count = cc
      end
      break if max_rank && max_rank < rank
      yield((rank == i ? rank : '-'), g)
    end
  end

  def before_view_date(dates, vd)
    dates.select{|d| d < vd}.sort.last
  end

  def after_view_date(dates, vd)
    dates.select{|d| d > vd}.sort.first
  end

end
