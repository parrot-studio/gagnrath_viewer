# coding: utf-8
class CacheData

  class << self

    def result_dates
      get_with_cache('result_dates') do
        Ruler.gvdates.reverse.take(ServerSettings.data_size)
      end
    end

    def guild_result_for_all
      get_with_cache('guild_result_all') do
        GuildResult.totalize(dates: result_dates).sort_by(&:called_count).reverse
      end
    end

    def call_rankers_for_all
      get_with_cache('call_rankers_for_all') do
        gs = guild_result_for_all.take(20).map(&:guild_name)
        dates = result_dates

        rankers = {}
        gs.each do |gname|
          GuildResult.for_guild(gname).where(gvdate: dates).each do |gr|
            rankers["#{gr.gvdate}_#{gr.guild_name}"] = gr
          end
        end
        rankers
      end
    end

    def call_rankers_for(date)
      return [] unless result_dates.include?(date)
      get_with_cache("call_rankers_for_#{date}") do
        GuildResult.where(gvdate: date).sort_by(&:called_count)
      end
    end

    def rulers_for(date)
      return {} unless result_dates.include?(date)
      get_with_cache("rulers_for_#{date}") do
        Ruler.for_date(date).inject({}){|h, r| h[r.fort_code] = r; h}
      end
    end

    def clear_all
      Rails.cache.clear
    end

    private

    def cache_enable?
      TimeUtil.in_battle_time? ? false : true
    end

    def get_with_cache(name, &b)
      return unless (name && b)
      return b.call unless cache_enable?

      data = Rails.cache.read(name)
      return data if data

      ret = b.call
      return unless ret
      Rails.cache.write(name, ret)

      ret
    end

  end

end
