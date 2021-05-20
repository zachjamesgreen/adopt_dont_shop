module ApplicationsHelper

  def get_statuses
    Application.statuses.to_a.map{ |s| [s[0].humanize, s[0]]}
  end
end
