class Minidoc
  module Counters
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def counter(field, options = {})
        start = options.fetch(:start, 0)
        step_size = options.fetch(:step_size, 1)

        attribute field, Integer, default: start

        class_eval(<<-EOM)
          def increment_#{field}
            Minidoc::Counters::Incrementor.
              new(self, :#{field}).increment(#{step_size})
          end
        EOM
      end
    end

    class Incrementor
      def initialize(record, field)
        @record = record
        @field = field
      end

      def increment(step_size = 1)
        result = record.class.collection.find_one_and_update(
          { _id: record.id },
          { "$inc" => { field => step_size } },
          return_document: :after,
        )

        result[field.to_s]
      end

      private

      attr_reader :record, :field
    end
  end
end
