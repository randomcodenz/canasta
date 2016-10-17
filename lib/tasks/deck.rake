namespace :deck do
  desc "Find RNG seed that returns a deck matching hardcoded rules"
  task find_seed: :environment do
    (1...999_999_999).each do |seed|
      deck = Deck.new(:seed => seed)
      dealer = Dealer.new(:deck => deck)
      the_deal = dealer.deal(:number_of_players => 2)

      if first_player_has_wild_card?(the_deal) && first_player_has_cards_of_same_rank?(the_deal, 3)

        puts "Seed found: #{seed}"
        puts "=== Player 1 hand ==="
        puts the_deal.player_hands[0].sort
        puts

        puts "=== Player 1 hand ==="
        puts the_deal.player_hands[1].sort
        puts

        puts "=== The first pick up ==="
        puts the_deal.stock[0..1].sort
        break
      end
    end
  end
end

def first_player_has_wild_card?(the_deal)
  the_deal.player_hands[0].any?(&:wild?)
end

def first_player_has_cards_of_same_rank?(the_deal, minimum_limit)
  ranks = the_deal.player_hands[0].select(&:natural?).map(&:rank)
  freq = ranks.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
  freq.values.max >= minimum_limit
end
