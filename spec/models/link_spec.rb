require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_url_of(:url) }

  let!(:user) { create :user }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:q_link) { create(:link, linkable: question, name: "q_gist", url: "https://gist.github.com/lbrezgin/5a5da66d54c86058e8cf68cdbc1e33e2") }
  let!(:a_link) { create(:link, linkable: answer, name: "a_gist", url: "https://gist.github.com/lbrezgin/5a5da66d54c86058e8cf68cdbc1e33e2") }

  context 'When linkable question' do
    describe ".gist?" do
      it 'return true if link is gist' do
        expect(q_link.gist?).to eq true
      end
    end

    describe ".get_id_from_url" do
      it 'return gist id from gist url' do
        expect(q_link.get_id_from_url(q_link.url)).to eq "5a5da66d54c86058e8cf68cdbc1e33e2"
      end
    end
  end

  context 'When linkable answer' do
    describe ".gist?" do
      it 'return true if link is gist' do
        expect(a_link.gist?).to eq true
      end
    end

    describe ".get_id_from_url" do
      it 'return gist id from gist url' do
        expect(a_link.get_id_from_url(a_link.url)).to eq "5a5da66d54c86058e8cf68cdbc1e33e2"
      end
    end
  end
end
