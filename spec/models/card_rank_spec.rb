require 'rails_helper'

describe CardRank, :type => :model do
  let(:card_ranks) { Card::RANKS + [Card::JOKER] }

  subject { CardRank.new(:rank => :queen) }

  it { is_expected.to validate_presence_of(:rank) }

  it { is_expected.to validate_length_of(:rank).is_at_most(10) }

  it do
    is_expected.to validate_uniqueness_of(:rank)
      .case_insensitive
  end

  it 'card ranks contains all of the ranks and "Joker"' do
    expect(CardRank.all.map(&:rank).map(&:to_sym)).to match(card_ranks)
  end

  describe '#from_rank' do
    let(:rank) { :queen }

    it 'returns the CardRank that matches the specified symbol' do
      expect(CardRank.from_rank(:rank => rank).rank).to eq rank.to_s
    end
  end
end
