class Minidoc
  module TestHelpers
    extend self

    def clear_databases(connections)
      connections.each { |connection| clear_database(connection) }
    end

    def clear_database(connection = Minidoc.connection)
      clear_collections(connection)
      clear_indexes(connection)
    end

    def clear_collections(connection = Minidoc.connection)
      each_collection(connection) { |c| c.remove({}) }
    end

    def clear_indexes(connection = Minidoc.connection)
      each_collection(connection, &:drop_indexes)
    end

    def each_collection(connection, &block)
      connection.db.collections.
        reject { |c| c.name.include?("system") }.
        each(&block)
    end
  end
end
