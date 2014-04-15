module ApplicationHelper
  include TimeUtil
  include FortUtil

  def server_name
    ServerSettings.env.server_name
  end

  def title_navs
    return if @title_navs.blank?
    [@title_navs].flatten.reject(&:blank?).reverse.inject(""){|s, n| s << "#{n} | " }
  end

  def adsense
    path = File.join(Rails.root, 'tmp', 'adsence.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

  def analytics
    path = File.join(Rails.root, 'tmp', 'analytics.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

  def amazon
    path = File.join(Rails.root, 'tmp', 'amazon.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

end
