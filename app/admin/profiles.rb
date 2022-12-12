ActiveAdmin.register Profile do
  permit_params :first_name, :last_name, :grade_id, :speciality_id, :user_id,
                user_attributes: %i[id email password password_confirmation],
                grade_attributes: %i[id name level],
                speciality_attributes: %i[id name]

  index do
    id_column
    column :first_name
    column :last_name
    column(:Grade_name) { |profile| profile.grade.name }
    column(:Grade_level) { |profile| profile.grade.level }
    column :speciality
    column :user
    column(:Role_name) { |profile| profile.user.roles }
  end

  controller do
    def create
      params_validator = ProfileParamsValidator.new(profile_params)

      if params_validator.valid?
        ProfileCreatorService.new.create_profile(profile_params.to_unsafe_hash)
        redirect_to admin_root_path
        flash[:notice] = 'Profile created!'
      else
        redirect_to new_admin_profile_path
        flash[:error] = params_validator.errors
      end
    end

    private

    def profile_params
      params.require(:profile)
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs 'Profile' do
      f.input :first_name
      f.input :last_name
    end

    f.inputs 'User', for: [:user, User.new] do |p|
      p.input :email
      p.input :password
      p.input :password_confirmation
      p.input :role_ids, label: 'Role', as: :select, collection: Role.all
    end

    f.inputs 'Select Speciality' do
      f.input :speciality
      f.inputs 'Or type speciality', for: [:speciality, f.object.speciality || Speciality.new] do |p|
        p.input :name
      end
    end

    f.inputs 'Select Grade' do
      f.input :grade
      f.inputs 'Or type grade', for: [:grade, f.object.grade || Grade.new] do |p|
        p.input :name
        p.input :level
      end
    end

    f.actions
  end

  action_item only: :index do
    link_to 'Upload CSV', action: 'upload_csv'
  end

  collection_action :upload_csv do
    render 'admin/csv/upload_csv'
  end

  collection_action :import_csv, method: :post do
    if params[:dump].present?

      import = CsvImportUsersService.new
      import.convert_save(params[:dump][:file])
      redirect_to({ action: :index })

      flash[:notice] = import.message.notice if import.message.notice.present?

      flash[:error] = import.message.error if import.message.error.present?

    else
      redirect_to({ action: :upload_csv })
      flash[:error] = 'File is not exists!'
    end
  end

  controller do
    def scoped_collection
      super.includes [user: :roles], :grade, :speciality
    end
  end
end
