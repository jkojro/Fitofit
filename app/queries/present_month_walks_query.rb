class PresentMonthWalksQuery
  def call(relation)
    relation
      .group_by_month(:created_at, last: 1, format: '%B')
      .group_by_day(:created_at).sum(:distance)
  end
end
