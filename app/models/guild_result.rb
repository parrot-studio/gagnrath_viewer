class GuildResult < ActiveRecord::Base
  include FortUtil

  validates :gvdate,
    presence: true,
    length: {maximum: 10}
  validates :guild_name,
    presence: true,
    length: {maximum: 50}
  validates :data,
    presence: true

  scope :for_date,  lambda{|d| where(gvdate: d) }
  scope :for_guild, lambda{|g| where(guild_name: g)}

  class << self

    def totalize(dates: nil)
      results = unless dates.blank?
        self.for_date(dates)
      else
        self.all
      end
      guilds = results.map(&:guild_name).uniq

      totals = []
      guilds.each do |gname|
        rsl = self.combine(results.select{|g| g.guild_name == gname})
        next unless rsl
        rsl.guild_name = gname
        totals << rsl
      end

      totals
    end

    def totalize_for_guild(gname, dates: nil)
      return unless gname
      results = self.for_guild(gname)
      results = results.for_date(dates) unless dates.blank?
      gr = self.combine(results)
      gr.guild_name = gname
      gr
    end

    def combine(results)
      return if results.blank?
      gr = self.new
      results.each{|g| gr.append(g)}
      gr
    end

  end

  def result
    @result ||= (self.data ? JSON.parse(self.data) : {})
    @result
  end

  def result=(r)
    @result = r
  end

  def called
    result['called'] ||= {}
    result['called']
  end

  def called=(ch)
    result['called'] = ch
  end

  def ruled
    result['ruled'] ||= {}
    result['ruled']
  end

  def ruled=(rh)
    result['ruled'] = rh
  end

  def called_count_fe
    @called_count_fe ||= count_for_fort_group(self.called, fort_groups_fe)
    @called_count_fe
  end

  def called_count_se
    @called_count_se ||= count_for_fort_group(self.called, fort_groups_se)
    @called_count_se
  end

  def called_count_te
    @called_count_te ||= count_for_fort_group(self.called, fort_groups_te)
    @called_count_te
  end

  def called_count
    called_count_fe + called_count_se + called_count_te
  end

  def called_count_for_group(g)
    count_for_fort_group(self.called, g)
  end

  def ruled_count_fe
    @ruled_count_fe ||= count_for_fort_group(self.ruled, fort_groups_fe)
    @ruled_count_fe
  end

  def ruled_count_se
    @ruled_count_se ||= count_for_fort_group(self.ruled, fort_groups_se)
    @ruled_count_se
  end

  def ruled_count_te
    @ruled_count_te ||= count_for_fort_group(self.ruled, fort_groups_te)
    @ruled_count_te
  end

  def ruled_count
    ruled_count_fe + ruled_count_se + ruled_count_te
  end

  def ruled_count_for_group(g)
    count_for_fort_group(self.ruled, g)
  end

  def has_forts?
    ruled_count > 0 ? true : false
  end

  def score
    @score ||= score_for_order_list(
      :ruled_count, :ruled_count_se, :ruled_count_fe, :ruled_count_te,
      :called_count, :called_count_se, :called_count_fe, :called_count_te)
    @score
  end

  def score_for_fe
    @score_for_fe ||= score_for_order_list(
      :ruled_count_fe, :ruled_count, :ruled_count_se, :ruled_count_te,
      :called_count_fe, :called_count, :called_count_se, :called_count_te)
    @score_for_fe
  end

  def score_for_se
    @score_for_se ||= score_for_order_list(
      :ruled_count_se, :ruled_count, :ruled_count_fe, :ruled_count_te,
      :called_count_se, :called_count, :called_count_fe, :called_count_te)
    @score_for_se
  end

  def score_for_te
    @score_for_te ||= score_for_order_list(
      :ruled_count_te, :ruled_count, :ruled_count_se, :ruled_count_fe,
      :called_count_te, :called_count, :called_count_se, :called_count_fe)
    @score_for_te
  end

  def append(g)
    self.called = merge_result(self.called, g.called)
    self.ruled = merge_result(self.ruled, g.ruled)
    self
  end

  private

  def merge_result(org, add)
    keys = [org.keys, add.keys].flatten.uniq.compact
    rsl = {}
    keys.each do |f|
      rsl[f] = org[f].to_i + add[f].to_i
    end
    rsl
  end

  def score_for_order_list(*list)
    return 0 if list.nil? || list.empty?
    times = 0
    score = 0
    [list].flatten.reverse.each do |m|
      score += self.__send__(m) * 10**times
      times += 4
    end
    score
  end

  def count_for_fort_group(data, group)
    gs = [group].flatten.uniq.compact
    count = 0
    data.each do |fcd, c|
      next unless gs.include?(fcd[0])
      count += c
    end
    count
  end

end
