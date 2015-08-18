module TinyMVC
  module DbApi
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def all
        raise NotImplementedError
      end

      def find(id)
        raise NotImplementedError
      end

      def count
        raise NotImplementedError
      end

      def create(options)
        new(options).save
      end

      def delete_all
        raise NotImplementedError
      end
    end

    # should generate @id for new record and return self
    def save
      raise NotImplementedError
    end

    # should return self
    def delete
      raise NotImplementedError
    end
  end
end
