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
    @errors << 'Profile params not set' if @params.dig(:first_name).blank? && @params.dig(:last_name).blank?

    if @params.dig(:grade_id).blank?
      grade_attributes = @params.dig(:grade_attributes)
      grade_fields = %i[name level]

      @errors << 'Grade params are not set' if grade_fields.any? { |f| grade_attributes.dig(f).blank? }
    end

    if @params.dig(:speciality_id).blank? && @params.dig(:speciality_attributes, :name).blank?
      @errors << 'Speciality params are not set'
    end

    user_attributes = @params.dig(:user_attributes)
    user_fields = %i[email password password_confirmation role_ids]

    @errors << 'User params are not set' if user_fields.any? { |f| user_attributes.dig(f).blank? }

    user_email = @params.dig(:user_attributes, :email)

    @errors << 'Email has already been taken' if User.find_by(email: user_email).present?

    password = @params.dig(:user_attributes, :password)
    password_confirmation = @params.dig(:user_attributes, :password_confirmation)

    return unless password != password_confirmation

    @errors << "Password confirmation doesn't match Password"
  end
end
