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
    redirect '/login' unless logged_in?
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

  post '/signup' do
    if !params[:password].empty? && !params[:username].empty?
      @user = User.create(username:params[:username],password:params[:password])
      @user.save
      directory_name = Dir.pwd + "/app/public/images/user_#{@user.id}"
      unless File.exists?(directory_name)  
        Dir.mkdir(directory_name) 
      else 
        redirect '/signup'
      end

      flash[:message] = "Successfully created user."
      redirect '/login'
    else
      flash[:message] = "Nothing should be blank."
      redirect '/signup'
    end
  end

end
