class GameSummaryPresenter < SimpleDelegator
  def round_over?
    !rounds.any?
  end
end
