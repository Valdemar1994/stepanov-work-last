require 'rails_helper'

RSpec.describe Profile, type: :model do

  it { is_expected.to belong_to(:speciality) }
  it { is_expected.to belong_to(:grade) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:pool) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:grade_id) }
  it { is_expected.to validate_presence_of(:speciality_id) }

  it { should respond_to(:speciality_id) }
  it { should respond_to(:grade_id) }
  it { should respond_to(:user_id) }

  it { should have_db_column(:first_name).of_type(:string).with_options(null: false) }
  it { should have_db_column(:last_name).of_type(:string).with_options(null: false) }
end
