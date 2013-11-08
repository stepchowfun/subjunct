class HomeController < ApplicationController
  # ensure that HTTPS is used
  before_filter :use_https

  def index
  end

  def about
  end

private
  # make sure we are using https
  # used as a before filter
  def use_https
    if Rails.env.production?
      if request.protocol != "https://"
        return redirect_to "https://#{request.url[(request.protocol.size)..(-1)]}"
      end
    end
  end
end
