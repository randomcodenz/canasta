require 'rails_helper'

describe RoundsHelper, :type => :helper do
  describe '#describe_pile_size' do
    context 'when number_of_cards is 1' do
      it 'returns "1 card"' do
        expect(describe_pile_size(1)).to eq '1 card'
      end
    end

    context 'when number_of_cards is 0' do
      it 'returns "empty"' do
        expect(describe_pile_size(0)).to eq 'empty'
      end
    end

    context 'when number_of_cards is > 1' do
      it 'returns "n cards" where n is number_of_cards' do
        expect(describe_pile_size(5)).to eq '5 cards'
      end
    end
  end
end
