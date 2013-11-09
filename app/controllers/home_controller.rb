include ActionView::Helpers::DateHelper
include ApplicationHelper

class HomeController < ApplicationController
  # ensure that HTTPS is used
  before_filter :use_https

  # number of posts on a page
  PAGE_SIZE = 20

  def index
    @posts = Post.order('created_at DESC').limit(PAGE_SIZE).map { |post|
      {
        :id => post.id,
        :question => post.question,
        :date => post.created_at,
        :ago => time_ago_in_words(post.created_at) + ' ago',
        :expanded => false,
      }
    }
  end

  def post
    begin
      id = params[:id].to_i
      @post = Post.find(id)
    rescue
      return render '404', :status => 404
    end
  end

  def batch
    begin
      date = DateTime.parse(params[:date])
    rescue
      return render :json => { :status => 'error', :reason => 'Bad timestamp.' }
    end

    posts = Post.where('created_at < ?', date).order('created_at DESC').limit(PAGE_SIZE).map { |post|
      {
        :id => post.id,
        :question => post.question,
        :date => post.created_at,
        :ago => time_ago_in_words(post.created_at) + ' ago',
        :expanded => false,
      }
    }
    puts posts

    return render :json => { :status => 'ok', :posts => posts }
  end

  def about
  end

  def new
    if params[:question].size < 1 || params[:question].size > MAX_QUESTION
      return render :json => { :status => 'error', :reason => 'Invalid question.' }
    end
    if params[:answer].size < 1 || params[:answer].size > MAX_ANSWER
      return render :json => { :status => 'error', :reason => 'Invalid answer.' }
    end
    if params[:message].size < 1 || params[:message].size > MAX_MESSAGE
      return render :json => { :status => 'error', :reason => 'Invalid message.' }
    end

    post = Post.create :question => params[:question], :answer => params[:answer], :message => params[:message]
    return render :json => { :status => 'ok', :post => post }
  end

private
  # make sure we are using https
  # used as a before filter
  def use_https
    if Rails.env.production?
      if request.protocol != 'https://'
        return redirect_to "https://#{request.url[(request.protocol.size)..(-1)]}"
      end
    end
  end
end
