module TinyMVC
  class BaseModel
    attr_reader :id

    def initialize(options = {})
      parameters = self.class.stored_parameters + [:id]
      parameters.each do |attr|
        instance_variable_set(:"@#{attr}", options[attr.to_s] || options[attr.to_sym])
      end
    end

    def self.stored_parameters(*args)
      return @stored_parameters if args.empty?
      @stored_parameters = *args
      @stored_parameters.freeze
      attr_accessor *args
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
      parameters = self.class.stored_parameters + [:id]
      parameters.reduce({}) do |hash, attr|
        hash.merge(attr => instance_variable_get("@#{attr}"))
      end
    end
  end
end
