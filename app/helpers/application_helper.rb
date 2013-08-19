module ApplicationHelper
  include TimeUtil
  include FortUtil

  def server_name
    ServerSettings.env.server_name
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
