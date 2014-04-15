# coding: utf-8
class ServerSettings < Settingslogic
  source File.expand_path('../../config/settings.yml', __FILE__)
  namespace Rails.env
  load!

  class << self

    def app_path
      self.env.app_path || ''
    end

    def secret_key_base
      Rails.application.secrets
    end

    def gvtype
      t = self.env.gvtype.to_s
      case t.upcase
      when 'FE', 'SE', 'FESE'
        'FE'
      when 'TE'
        'TE'
      else
        'FE'
      end
    end

    def gvtype_fe?
      gvtype == 'FE' ? true : false
    end

    def gvtype_te?
      gvtype == 'TE' ? true : false
    end

    def memcache_server
      self.memcache.server.blank? ? 'localhost:11211' : self.memcache.server
    end

    def memcache_namespace
      self.memcache.namespace + '_gagnrath'
    end

    def memcache_expire_time
      min = self.memcache.expire.to_i
      (min > 0 ? min : 1).minutes
    end

    def data_size
      val = self.env.data_size.to_i
      return 6 if val < 4 || val > 12
      val
    end

  end

end
