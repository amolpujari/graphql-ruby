# frozen_string_literal: true
module GraphQL
  class TermsheetCustomField
    def self.make(schema, node_name, has_custom_fields_type='Project')
      return unless ::CustomField::ValidRelatedTypes.include?(has_custom_fields_type)

      return unless node_name.start_with?('cf_')

      cf_kind = node_name.split('_')[1]
      return unless ::CustomField.kinds.keys.include?(cf_kind)

      field = schema.get_field(has_custom_fields_type, "cf_#{cf_kind}")
      return unless field

      field = field.dup

      field.name = node_name
      field.metadata[:type_class].instance_variable_set "@underscored_name", node_name
      field.metadata[:type_class].instance_variable_set "@name", node_name
      field.metadata[:type_class].instance_variable_set "@original_name", node_name.to_sym
      field.metadata[:type_class].instance_variable_set "@resolver_method", node_name.to_sym
      field.metadata[:type_class].instance_variable_set "@method_str", node_name
      field.metadata[:type_class].instance_variable_set "@method_sym", node_name.to_sym

      field
    end
  end
end
