require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:ratings) }
  end

  describe 'validations' do
    subject { described_class.new(login: 'testuser') }

    it { is_expected.to validate_presence_of(:login) }
  end
end
