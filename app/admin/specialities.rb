ActiveAdmin.register Speciality do

  permit_params :name

  index do
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :name
    end
    f.actions
  end

end
