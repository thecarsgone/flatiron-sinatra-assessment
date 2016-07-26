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

  get '/' do
    erb :index
  end

  get '/login' do
  end

  get '/signup' do
    erb :'users/user_create'
  end

  post '/signup' do
    User.create(username:params[:username],password:params[:password])
    flash[:message] = "Successfully created user."
    redirect '/login' do
    end
  end

end
