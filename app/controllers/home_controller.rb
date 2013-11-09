include ActionView::Helpers::DateHelper
include ApplicationHelper
include ERB::Util

class HomeController < ApplicationController
  # ensure that HTTPS is used
  before_filter :use_https

  # number of posts on a page
  PAGE_SIZE = 20

  def index
    @posts = Post.order('created_at DESC').limit(PAGE_SIZE + 1).map { |post|
      {
        :id => post.id,
        :question => post.question,
        :date => post.created_at,
        :ago => time_ago_in_words(post.created_at) + ' ago',
        :expanded => false,
        :answered => false,
        :answer => '',
        :message => '',
      }
    }
    @more = @posts.size == PAGE_SIZE + 1
    @posts = @posts.first(PAGE_SIZE)
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

    posts = Post.where('created_at < ?', date).order('created_at DESC').limit(PAGE_SIZE + 1).map { |post|
      {
        :id => post.id,
        :question => post.question,
        :date => post.created_at,
        :ago => time_ago_in_words(post.created_at) + ' ago',
        :expanded => false,
        :answered => false,
        :answer => '',
        :message => '',
      }
    }

    return render :json => { :status => 'ok', :posts => posts.first(PAGE_SIZE), :more => (posts.size == PAGE_SIZE + 1) }
  end

  def check
    begin
      id = params[:id].to_i
      post = Post.find(id)
    rescue
      return render :json => { :status => 'error', :reason => 'Bad post ID.' }
    end

    if check_answers(post.answer, params[:answer])
      message = (html_escape post.message).split("\n").select{ |line| line != "" }.map{ |line| "<p>" + line + "</p>" }.join
      return render :json => { :status => 'ok', :message => message, :answer => post.answer }
    else
      return render :json => { :status => 'error', :reason => 'Wrong answer.' }
    end
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
  # check if two answers match
  def check_answers(answer1, answer2)
    return answer1.downcase.split.join(' ') == answer2.downcase.split.join(' ')
  end

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
