module TinyMVC
  module Associations
    module BelongsTo
      def belongs_to(model)
        define_method model do
          Object.const_get(model.to_s.upcase).find(self.send("#{model}_id"))
        end

        define_method "#{model}=" do |m|
          instance_variable_set("@#{model}", m)
          instance_variable_set("@#{model}_id", m.id)
          m
        end

        define_method "build_#{model}" do |opts|
          Object.const_get(model.to_s.upcase).new(opts).tap do |m|
            self.send("#{model}=", m)
          end
        end

        define_method "create_#{model}" do |opts|
          self.send("build_#{model}", opts).save
        end
      end
    end

    module HasOne
      def has_one(model)
        define_method model do
          Object.const_get(model.to_s.upcase).find("#{self.class.name.downcase}_id" => self.id)
        end

        define_method "#{model}=" do |m|
          instance_variable_set("@#{model}", m)
          instance_variable_set("@#{model}_id", m.id)
          m.save
        end

        define_method "build_#{model}" do |opts|
          Object.const_get(model.to_s.upcase).new(opts).tap do |m|
            m.send("#{self.class.name.downcase}_id", self.id)
            instance_variable_set("@#{model}", m)
          end
        end

        define_method "create_#{model}" do |opts|
          self.send("build_#{model}", opts).save
        end
      end
    end
  end
end