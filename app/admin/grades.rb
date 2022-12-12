ActiveAdmin.register Grade do

  permit_params :name, :level

  index do
    id_column
    column(:Name) { |grade| grade.name }
    column(:Level) { |grade| grade.level }
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :level

  show do
    attributes_table do
      row :name
      row :level
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :name
      f.input :level
    end
    f.actions
  end
end
