module FixAllCollision
  # Fix the collision between capybara "all" and rspec "all". "all" gets
  # redefined to the capybara node finder because capybara is loaded after
  # rspec so alias the rspec "all" matcher to "all_the_things"
  def all_the_things(expected)
    RSpec::Matchers::BuiltIn::All.new(expected)
  end
end
World(FixAllCollision)
