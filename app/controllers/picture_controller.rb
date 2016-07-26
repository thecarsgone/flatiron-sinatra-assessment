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
     ratio = params["common"].split(":").map{|x| x.to_f}
     @dimensions = proportional_crop(@path, ratio)

     redirect '/pictures/:id'

  end

  get '/test' do
    erb :'pictures/show'
  end



  def slugify(string)
    string.gsub(" ", "-")
  end

  def proportional_crop(file_path, ratio)
    current_dimensions = FastImage.size('app/public' + @path)
    unit = current_dimensions[0] / ratio[0]
    new_dimensions = [(ratio[0] * unit), (ratio[1] * unit)]
  end


end
