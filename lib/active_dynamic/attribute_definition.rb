require 'sanitize'

module ActiveDynamic
  class AttributeDefinition < ActiveRecord::Base
    has_many :active_dynamic_attributes, class_name: 'ActiveDynamic::Attribute', dependent: :destroy, foreign_key: :active_dynamic_definition_id
    validates :name, :datatype, :field_definable_id, :field_definable_type, presence: true

    before_validation :sanitize

    validate :cannot_be_reserved_word, :no_greater_than_32

    self.table_name = :active_dynamic_definitions

    def cannot_be_reserved_word
      errors.add(:name, "Field name, '#{name}', is not allowed.") if respond_to?(name)
    end

    def no_greater_than_32
      errors.add(:name, "Field name must be between 3 and 32 characters") if name.length > 32 || name.length < 3
    end

    def sanitize
      # strip all html. Remove all whitespace
      self.name = Sanitize.fragment(self.name.gsub(/\s+/, ''))
    end
  end
end
