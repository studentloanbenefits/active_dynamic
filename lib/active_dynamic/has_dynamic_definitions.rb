module ActiveDynamic
  module HasDynamicDefinitions
    extend ActiveSupport::Concern

    included do
      has_many :active_dynamic_definitions,
               class_name: 'ActiveDynamic::AttributeDefinition',
               autosave: true,
               dependent: :destroy,
               as: :field_definable

      accepts_nested_attributes_for :active_dynamic_definitions, allow_destroy: true
    end
  end
end
