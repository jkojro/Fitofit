class PresentWeekWalksDistance
  def call(user)
    user
      .walks
      .group_by_week(:created_at, last: 1)
      .sum(:distance).values.first
  end
end
