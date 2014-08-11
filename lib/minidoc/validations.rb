module Minidoc::Validations
  class UniquenessValidator < ::ActiveModel::EachValidator
    def initialize(options)
      super(options.reverse_merge(case_sensitive: true))
    end

    def validate_each(record, attribute, value)
      conditions = scope_conditions(record)

      if options[:case_sensitive]
        conditions[attribute] = value
      else
        conditions[attribute] = /^#{Regexp.escape(value.to_s)}$/i
      end

      # Make sure we're not including the current document in the query
      if record._id
        conditions[:_id] = { "$ne" => record.id }
      end

      if record.class.exists?(conditions)
        record.errors.add(
          attribute,
          :taken,
          options.except(:case_sensitive, :scope).merge(value: value)
        )
      end
    end

    def message(instance)
      super || "has already been taken"
    end

    def scope_conditions(instance)
      Array(options[:scope]).inject({}) do |conditions, key|
        conditions.merge(key => instance[key])
      end
    end
  end
end
