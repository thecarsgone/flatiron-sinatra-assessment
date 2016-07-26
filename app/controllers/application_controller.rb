require 'rack-flash'
require './config/environment'

class ApplicationController < Sinatra::Base
#add this line for edit or delete in views
#<input id="hidden" type="hidden" name="_method" value="patch/delete">
  use Rack::Flash
  configure do
    set :public_folder, 'public'
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
    erb :'login'
  end

  get '/index' do
    erb :index
  end

  get '/login' do
    erb :login
  end

  get '/signup' do
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
  
  post '/signup' do
    redirect '/index' if logged_in?
    if !params[:password].empty? && params[:username].empty?
      User.create(username:params[:username],password:params[:password]).save
      flash[:message] = "Successfully created user."
      redirect '/login'
    end
  end

end
