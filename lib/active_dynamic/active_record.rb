module ActiveDynamic
  module ActiveRecord

    def has_dynamic_attributes
      include ActiveDynamic::HasDynamicAttributes
    end

    def has_dynamic_definitions
      include ActiveDynamic::HasDynamicDefinitions
    end

  end
end

ActiveRecord::Base.extend ActiveDynamic::ActiveRecord
