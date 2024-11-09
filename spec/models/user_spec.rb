require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it {should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.author_of?' do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

    it "returns true if the user is the object's author" do
      expect(author.author_of?(question)).to eq true
      expect(author.author_of?(answer)).to eq true
    end

    let(:non_author) { create(:user) }
    it "returns false if the user isn't the object's author" do
      expect(non_author.author_of?(question)).to eq false
      expect(non_author.author_of?(answer)).to eq false
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let!(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth[:provider], auth[:uid], user.email).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth[:provider], auth[:uid], user.email)
    end
  end
end
