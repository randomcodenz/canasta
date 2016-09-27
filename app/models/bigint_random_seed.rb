module BigIntRandomSeed
  MAX_VALUE = 2**63 - 1

  # Generate a seed value that we can safely store in an 8 bit integer (bigint)
  def self.new_seed
    Random.new.rand(MAX_VALUE)
  end
end
