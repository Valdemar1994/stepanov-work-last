require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { is_expected.to have_one(:profile) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { should have_db_column(:email).of_type(:string).with_options(null: false) }
end
