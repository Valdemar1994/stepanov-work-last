require 'rails_helper'

RSpec.describe PoolsController, type: :controller do
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

  before { sign_in user }
  
  describe '#index' do
    subject { process :index }
    
    it 'manager render index template' do
      subject
      expect(response).to render_template :index
    end
  end

  describe '#create' do
    subject { process :create, method: :post, params: params }

    context 'when params is valid' do
      let(:params) { { pool: attributes_for(:pool, profile_id: profile) } }
            
      it 'creates a new pool when user role has manager' do
        user.add_role :manager
        expect { subject }.to change { Pool.count }.by(1)
      end

      it 'redirect to poot path' do
        subject
        expect(response).to redirect_to root_path
      end

      it 'assigns pool to profile' do
        subject
        expect(assigns(:pool).profile).to eq profile
      end

      xit 'trying create new pool when user role has user' do
        user.add_role :user
        expect { subject }.not_to change { Pool.count }
      end
    end

    context 'when params is invalid' do
      let(:params) { { pool: attributes_for(:pool) } }

      it 'doesnt create a pool' do
        expect { subject }.not_to change { Pool.count }
      end

      it 'redirect to pool path' do
        expect(subject).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do

    subject { process :destroy, method: :delete, params: params }

    context 'when params is valid' do
      let!(:pool) { create :pool, profile_id: profile.id }
      let!(:other_pool) { create :pool, profile_id: other_profile.id, parent_id: pool.id }
      let(:params) { { id: other_pool.id } }
      
      it 'destroy pool when user role has manager' do
        user.add_role :manager
        expect { subject }.to change { Pool.count }.by(-1)
      end

      it 'after destroy redirect to poot path' do
        expect(subject).to redirect_to root_path
      end

      it 'trying destroy pool when user role = user' do
        user.add_role :user
        expect { subject }.not_to change { Pool.count }
      end
    end

    context 'trying destroy root pool' do

      let!(:pool) { create :pool, profile_id: profile.id }
      let(:params) { { id: pool.id } }

      it 'where pool id = nil (root)' do
        user.add_role :manager
        expect { subject }.not_to change { Pool.count }
      end

      it 'after fail destroy redirect to poot path' do
        expect(subject).to redirect_to root_path
      end
    end
  end

  describe "#pool_graph" do

    context 'build pool graph to file' do
      let!(:pool) { create :pool, profile_id: profile.id }

      it 'pool' do

      end
    end
  end
end
