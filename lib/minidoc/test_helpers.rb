class Minidoc
  module TestHelpers
    extend self

    def clear_database
      clear_collections
      clear_indexes
    end

    def clear_collections
      each_collection { |c| c.remove({}) }
    end

    def clear_indexes
      each_collection(&:drop_indexes)
    end

    def each_collection(&block)
      Minidoc.database.collections.
        reject { |c| c.name.include?("system") }.
        each(&block)
    end
  end
end
