module ActiveDynamic
  module HasDynamicAttributes
    extend ActiveSupport::Concern

    included do
      has_many :active_dynamic_attributes,
               class_name: 'ActiveDynamic::Attribute',
               autosave: true,
               dependent: :destroy,
               as: :customizable
      before_save :save_dynamic_attributes
    end

    def dynamic_field_definitions
      resolve_from_provider
    end

    def dynamic_field_definitions_loaded?
      @dynamic_field_definitions_loaded ||= false
    end

    def respond_to?(method_name, include_private = false)
      if super
        true
      else
        load_dynamic_field_definitions unless dynamic_field_definitions_loaded?
        dynamic_field_definitions.find { |attr| attr.name == method_name.to_s.delete('=') }.present?
      end
    end

    def method_missing(method_name, *arguments, &block)
      if dynamic_field_definitions_loaded?
        super
      else
        load_dynamic_field_definitions
        send(method_name, *arguments, &block)
      end
    end

    private

    def should_resolve_persisted?
      value = ActiveDynamic.configuration.resolve_persisted
      case value
      when TrueClass, FalseClass
        value
      when Proc
        value.call(self)
      else
        raise "Invalid configuration for resolve_persisted. Value should be Bool or Proc, got #{value.class}"
      end
    end

    def any_dynamic_attributes?
      active_dynamic_attributes.any?
    end

    def resolve_from_provider
      ActiveDynamic.configuration.provider_class.new(self).call
    end

    def generate_accessors(fields)
      fields.each do |field_def|
        add_presence_validator(field_def.name) if field_def.required?

        define_singleton_method(field_def.name) do
          _custom_fields[field_def.name]
        end

        define_singleton_method("#{field_def.name}=") do |value|
          _custom_fields[field_def.name] = value && value.to_s.strip
        end

      end
    end

    def add_presence_validator(attribute)
      singleton_class.instance_eval do
        validates_presence_of(attribute)
      end
    end

    def _custom_fields
      @_custom_fields ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    def load_dynamic_field_definitions
      dynamic_field_definitions.each do |ticket_field|
        dynamic_field = ActiveDynamic::Attribute.where(customizable_id: id, active_dynamic_definition_id: ticket_field.id)
        value = dynamic_field.any? ? dynamic_field.first.value : nil
        _custom_fields[ticket_field.name] = value
      end

      generate_accessors dynamic_field_definitions
      @dynamic_field_definitions_loaded = true
    end

    def save_dynamic_attributes
      dynamic_field_definitions.each do |field_def|
        next unless _custom_fields[field_def.name]
        attr = active_dynamic_attributes.find_or_initialize_by(customizable_id: id, customizable_type: self.class.name, active_dynamic_definition_id: field_def.id)
        if persisted?
          attr.update(value: _custom_fields[field_def.name])
        else
          attr.assign_attributes(value: _custom_fields[field_def.name])
        end
      end
    end

  end
end
