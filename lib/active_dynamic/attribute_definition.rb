require 'loofah'

module ActiveDynamic
  class AttributeDefinition < ActiveRecord::Base
    has_many :active_dynamic_attributes, class_name: 'ActiveDynamic::Attribute', dependent: :destroy, foreign_key: :active_dynamic_definition_id
    validates :name, :datatype, :field_definable_id, :field_definable_type, presence: true

    before_validation :sanitize

    validate :cannot_be_reserved_word, :no_greater_than_32, :cannot_violate_ruby_method_restrictions, :cannot_be_duplicate

    self.table_name = :active_dynamic_definitions

    def cannot_be_reserved_word
      errors.add(:name, "Field name, '#{name}', is not allowed.") if respond_to?(name)
    end

    def cannot_violate_ruby_method_restrictions
      if !/((?=!|\?|=|\*|~)|^([A-Z]|[0-9]))/.match(self.name).nil?
        errors.add(:name, "Field cannot start with a number or capital, and cannot contain the characters !,?,~,=,*")
      end
    end

    def no_greater_than_32
      errors.add(:name, "Field name must be between 3 and 20 characters") if name.length > 20 || name.length < 3
    end

    def cannot_be_duplicate
      if ActiveDynamic::AttributeDefinition.where(field_definable_id: field_definable_id, name: name).any?
        errors.add(:name, "Field has already been taken")
      end
    end

    def sanitize
      # strip all html. Remove all whitespace
      self.name =Loofah.document(self.name.gsub(/\s+/, '')).scrub!(:prune).text
    end
  end
end
