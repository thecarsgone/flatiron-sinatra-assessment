require 'rack-flash'
require './config/environment'

class ApplicationController < Sinatra::Base
#add this line for edit or delete in views
#<input id="hidden" type="hidden" name="_method" value="patch/delete">
  use Rack::Flash
  configure do
    set :public_folder, Proc.new { File.join(root, "../public/") }
    set :views, 'app/views'
    #enable sessions here
		enable :sessions
		#set :session_secret, "secret"
    set :session_secret, "password_security"
  end

  #helper methods
  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

  #main controller action
  get '/' do
    redirect '/index' if logged_in?
    redirect '/login'
  end

  get '/index' do
    erb :index
  end

  get '/login' do
    redirect '/index' if logged_in?
    erb :login
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/signup' do
    redirect '/index' if logged_in?
    erb :'users/user_create'
  end

  post '/' do
    @user = User.find_by(username:params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      flash[:messsae] = "Successfully logged in."
      redirect '/index'
    else
      flash[:messsae] = "Log in failed."
      redirect '/login'
    end
  end


end
