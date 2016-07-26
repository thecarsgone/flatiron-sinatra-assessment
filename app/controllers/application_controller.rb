require './config/environment'

class ApplicationController < Sinatra::Base
#add this line for edit or delete in views
#<input id="hidden" type="hidden" name="_method" value="patch/delete">
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #enable sessions here
		enable :sessions
		#set :session_secret, "secret"
    set :session_secret, "password_security"
  end

end
