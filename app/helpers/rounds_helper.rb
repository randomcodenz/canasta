module RoundsHelper
  def describe_pile_size(number_of_cards)
    if number_of_cards.zero?
      'empty'
    elsif number_of_cards == 1
      '1 card'
    else
      "#{number_of_cards} cards"
    end
  end
end
