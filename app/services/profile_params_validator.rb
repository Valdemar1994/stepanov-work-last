class ProfileParamsValidator

  attr_reader :errors

  def initialize(params)
    @errors = []
    @params = params
  end
  
  def valid?
    validate
    @errors.empty?
  end

  def validate
    
    if @params.dig(:first_name).blank? && @params.dig(:last_name).blank?
      @errors << "Profile params not set"
    end

    if @params.dig(:grade_id).blank?
      grade_attributes = @params.dig(:grade_attributes)
      grade_fields = [:name, :level]
      
      if grade_fields.any? { |f| grade_attributes.dig(f).blank? }
        @errors << "Grade params are not set"
      end
    end

    if @params.dig(:speciality_id).blank?
      if @params.dig(:speciality_attributes, :name).blank?
        @errors << "Speciality params are not set"
      end
    end

    user_attributes = @params.dig(:user_attributes)
    user_fields = [:email, :password, :password_confirmation, :role_ids]

    if user_fields.any? { |f| user_attributes.dig(f).blank? }
      @errors << "User params are not set"
    end

    user_email = @params.dig(:user_attributes, :email)

    if User.find_by(email: user_email).present?
      @errors << "Email has already been taken"
    end

    password = @params.dig(:user_attributes, :password)
    password_confirmation = @params.dig(:user_attributes, :password_confirmation)
    
    if password != password_confirmation
      @errors << "Password confirmation doesn't match Password"
    end
  end
end
