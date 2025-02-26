require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:author) { User.create!(login: 'testuser1') }
  let(:other_user) { User.create!(login: 'testuser2') }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:ratings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:ip) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'average_rating' do
    let(:post) { described_class.create!(title: 'Test', body: 'Test11', ip: '192.168.0.40', user: author) }

    context 'with 2 rating' do
      before do
        post.ratings.create!(user: author, value: 4)
        post.ratings.create!(user: other_user, value: 5)
      end

      it 'return correct avg' do
        expect(post.average_rating).to eq(4.5)
      end
    end

    context 'with 1 rating' do
      before do
        post.ratings.create!(user: author, value: 3)
      end

      it 'return rating val' do
        expect(post.average_rating).to eq(3)
      end
    end
  end
end
