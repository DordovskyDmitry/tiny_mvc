require_relative 'db_api'

module TinyMVC
  class BaseModel
    include TinyMVC::DbApi
    attr_reader :id

    def initialize(options = {})
      self.class.attributes.each do |attr|
        if attr.to_sym == :id
          @id = options[:id] || options['id']
        else
          value = options[attr.to_s] || options[attr.to_sym]
          self.send("#{attr}=", value) unless value.nil?
        end
      end
    end

    def self.attributes(attrs = nil)
      @attrs ||= [:id]
      return @attrs unless attrs

      attrs.reject{|x| x.to_sym == :id}.each { |attr, type| add_attribute(attr, type) }

      @attrs += attrs.keys
      @attrs.uniq!
    end

    def ==(obj)
      self.class == obj.class && obj.id && self.id == obj.id
    end

    def new_record?
      self.id.nil?
    end

    def attributes
      self.class.attributes.reduce({}) do |hash, attr|
        hash.merge(attr => self.send(attr))
      end
    end

    private

    def self.add_attribute(attr, type)
      attr_reader attr

      define_method "#{attr}=" do |value|
        instance_variable_set(:"@#{attr}", type_cast(value, type))
      end
    end

    def type_cast(value, type = nil)
      return if value.nil?
      case type.to_sym
        when :integer
          value.to_i
        when :float
          value.to_f
        when :string
          value.to_s
        else
          value
      end
    end
  end
end
