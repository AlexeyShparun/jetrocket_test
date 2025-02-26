require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { User.create!(login: 'testuser') }
  let(:post) { Post.create!(title: 'Test', body: 'Test11', ip: '192.168.0.40', user: user) }

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { described_class.new(user: user, post: post, value: 5) }

    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_numericality_of(:value).only_integer }
    it { is_expected.to validate_numericality_of(:value).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:value).is_less_than_or_equal_to(5) }
  end

  describe 'valid rating' do
    it 'creates with valid attributes' do
      rating = described_class.new(user: user, post: post, value: 5)
      expect(rating).to be_valid
    end
  end
end
