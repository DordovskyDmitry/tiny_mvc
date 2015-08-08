require 'redis'
require 'json'

module TinyMVC
  class RedisModel < BaseModel

    def self.inherited(_)
      @@connection ||= begin
        redis_config = JSON.parse(File.read(TinyMVC.root + '/config/redis.json'))
         ::Redis.new(redis_config)
      end
    end

    def self.connection
      @@connection
    end

    def self.all
      get(self.name).values.map{|attrs| self.new(attrs) }
    end

    def self.find(id)
      get_raw = get(self.name)[id.to_s]
      self.new(get_raw) if get_raw
    end

    def self.count
      get(self.name).count
    end

    def self.delete_all
      set(self.name, nil)
    end

    def save
      @id ||= (get(self.class.name).keys.map(&:to_i).max || 0) + 1
      set(self.class.name, get(self.class.name).merge(@id => attributes))
      self
    end

    def delete
      set(self.class.name, get(self.class.name).reject{|k| k == self.id.to_s})
      #@id = nil TODO Think about it
      self
    end

    private

    def self.get(key)
      JSON.parse(@@connection.get(key) || '{}')
    end

    def get(key)
      self.class.get(key)
    end

    def self.set(key, value)
      @@connection.set(key, value.to_json)
    end

    def set(key, value)
      self.class.set(key, value)
    end
  end
end
