class PictureController < ApplicationController

  get '/pictures/new' do
    erb :'pictures/picture_create'
  end

  post '/pictures/new' do
    user = current_user
    picture = Picture.create(name: Picture.slugify(params['myfile'][:filename]), user: user)
    picture.upload(params['myfile'][:tempfile])
    params[:common].empty? ? picture.ratio = params[:ratio].join(":") : picture.ratio = params[:common]
    picture.save
    redirect "/pictures/#{picture.id}"
  end

  get '/pictures/:id' do
    @picture = Picture.find(params[:id])
    @dimensions = @picture.proportional_crop
    erb :'pictures/show'
  end




end
