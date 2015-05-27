class Minidoc
  module TestHelpers
    extend self

    def clear_database
      Minidoc.database.collections.each do |coll|
        next if coll.name.include?("system")
        coll.remove({})
        coll.drop_indexes
      end
    end
  end
end
