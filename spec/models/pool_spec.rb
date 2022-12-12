require 'rails_helper'

RSpec.describe Pool, type: :model do
  it { is_expected.to belong_to(:profile) }

  it { should have_db_column(:type).of_type(:string).with_options(null: false) }

  it { should respond_to(:profile_id) }
  it { should respond_to(:parent_id) }

  it { is_expected.to validate_presence_of(:type) }

  describe "behavior parent id" do

    let(:user) { create :user }
    let(:grade) { create :grade }
    let(:speciality) { create :speciality }
    let(:profile) { create :profile, user: user, grade: grade, 
    speciality: speciality }
  
    let(:other_user) { create :user }
    let(:other_grade) { create :grade }
    let(:other_speciality) { create :speciality }
    let(:other_profile) { create :profile, user: other_user, grade: other_grade, 
    speciality: other_speciality }

    let(:oother_user) { create :user }
    let(:oother_grade) { create :grade }
    let(:oother_speciality) { create :speciality }
    let(:oother_profile) { create :profile, user: oother_user, grade: oother_grade, 
    speciality: oother_speciality }

    let(:pool) { create :pool, profile_id: profile.id }
    let(:other_pool) { create :pool, profile_id: other_profile.id, parent_id: pool.id }
    let(:oother_pool) { create :pool, profile_id: oother_profile.id, parent_id: other_pool.id }

    it "change parent id" do
      expect{ other_pool.destroy }.to change{ oother_pool.reload.parent_id }.from(2).to(1)
      expect{ pool.destroy }.to change{ oother_pool.reload.parent_id }.from(1).to(nil)
    end
  end
end
