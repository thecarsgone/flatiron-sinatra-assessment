class PictureController < ApplicationController

  get '/pictures/new' do
    redirect '/login' unless logged_in?
    erb :'pictures/picture_create'
  end

  post '/pictures/new' do
    user = current_user
    picture = Picture.create(name: Picture.slugify(params['myfile'][:filename]), user: user)
    picture.upload(params['myfile'][:tempfile])
    params[:ratio].all?{|x| x.to_i > 0} ? picture.ratio = params[:ratio].join(":") : picture.ratio = params[:common]
    picture.save
   redirect "/pictures/#{picture.id}"
  end

  get '/pictures/:id' do
    @picture = Picture.find(params[:id])
    @dimensions = @picture.proportional_crop
    erb :'pictures/show'
  end

  get '/pictures/:id/edit' do
    picture = Picture.find(params[:id])
    if !logged_in? || picture.user_id != current_user.id
      redirect "/pictures/#{picture.id}/error"
    else
      @picture = Picture.find(params[:id])
      @dimensions = @picture.proportional_crop
      erb :'pictures/edit'
    end
  end

  patch '/pictures/:id' do
    picture = Picture.find(params[:id])
    params[:ratio].all?{|x| x.to_i > 0} ? picture.update(ratio: params[:ratio].join(":")) : picture.update(ratio: params[:common])
    redirect "/pictures/#{picture.id}"
  end

  delete '/pictures/:id' do
    picture = Picture.find(params[:id])
    picture.remove
    redirect '/index'
  end

  get '/pictures/:id/error' do
    @picture = Picture.find(params[:id])
    erb :'pictures/error'
  end


end
