class PictureController < ApplicationController

  get '/pictures/new' do
    erb :'pictures/picture_create'
  end

  post '/pictures/new' do
    ##TODO: get user id from session
    #make a new folder in public/images for each user


    # form returns 2 major params -- the uploaded file and the chosen ratio.
    # First, the filename is slugified for easier access
    params['myfile'][:filename] = slugify(params['myfile'][:filename])

    #then the file is locally uploaded to the public/images folder so sinatra can display it
    File.open('app/public/images/' + params['myfile'][:filename], "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end

    #this path is used in HTML/ERB for display purposes
     @path = "/images/#{params['myfile'][:filename]}"

     #code below is used to determine the size of the boxes on either side of the pic
     if !params["common"].empty?
     ratio = params["common"].split(":").map{|x| x.to_f}
     @box_proportion = (1 - (ratio[1]/ratio[0]))/2 * 100

     redirect '/pictures/:id'
   end
     #to determine bar size where x:y, you use the calculation (1 - (y / x))/2
     #will have to put an exception where y > x
  end

  get '/test' do
    erb :'pictures/show'
  end



  def slugify(string)
    string.gsub(" ", "-")
  end


end
