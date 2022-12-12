require 'rails_helper'

RSpec.describe SnapshotsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }
  
  describe '#index' do
    subject { process :index }
    
    it 'render index template' do
      subject
      expect(response).to render_template :index
    end
  end
end
