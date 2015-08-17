module TinyMVC
  class BaseModel
    def initialize(options = {})
      self.class.attributes.each do |attr|
        self.send("#{attr}=", options[attr.to_s] || options[attr.to_sym])
      end
    end

    def self.attributes(attrs = nil)
      @attrs ||= add_attribute(:id, :integer) && [:id]
      return @attrs unless attrs

      attrs.each { |attr, type| add_attribute(attr, type) }

      @attrs += attrs.keys
      @attrs.uniq!
    end

    def self.all
      raise NotImplementedError
    end

    def self.find(id)
      raise NotImplementedError
    end

    def self.count
      raise NotImplementedError
    end

    def self.create(options)
      new(options).save
    end

    def self.delete_all
      raise NotImplementedError
    end

    # should generate @id for new record and return self
    def save
      raise NotImplementedError
    end

    # should return self
    def delete
      raise NotImplementedError
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
