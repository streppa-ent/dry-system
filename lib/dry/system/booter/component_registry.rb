module Dry
  module System
    class Booter
      class ComponentRegistry
        include Enumerable

        attr_reader :components

        def initialize
          @components = []
        end

        def each(&block)
          components.each(&block)
        end

        def register(component)
          @components << component
        end

        def exists?(name)
          components.any? { |component| component.identifier == name }
        end

        def [](name)
          component = components.detect { |component| component.identifier == name }

          if component
            component
          else
            raise InvalidComponentIdentifierError, name
          end
        end
      end
    end
  end
end
