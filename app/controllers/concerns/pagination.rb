module Pagination
  extend ActiveSupport::Concern

  def default_per_page
    5
  end

  def per_page
    params[:page]&.to_i || default_per_page
  end
end
