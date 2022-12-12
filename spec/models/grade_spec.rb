require 'rails_helper'

RSpec.describe Grade, type: :model do

  it { is_expected.to validate_uniqueness_of(:name) }

  it { should respond_to(:name) }
  it { should respond_to(:level) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:level) }
end
