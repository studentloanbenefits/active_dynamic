class CreateActiveDynamicAttributesTable < ActiveRecord::Migration[4.2]

  def change
    create_table :active_dynamic_attributes, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.belongs_to :active_dynamic_definition, type: :uuid, null: false, index: true
      t.uuid :customizable_id, null: false
      t.string :customizable_type, null: false, limit: 50
      t.text :value
      t.timestamps
    end

    create_table :active_dynamic_definitions, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.uuid :field_definable_id, null: false
      t.string :field_definable_type, null: false, limit: 50
      t.string :name, null: false
      t.integer :datatype, null: false, default: 0
      t.boolean :required, null: false, default: false
      t.timestamps
    end

    add_index :active_dynamic_attributes, :customizable_id
    add_index :active_dynamic_attributes, :customizable_type
    add_index :active_dynamic_definitions, :field_definable_id
    add_index :active_dynamic_definitions, :field_definable_type
  end

end
