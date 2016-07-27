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
    @picture = Picture.find(params[:id])
    @dimensions = @picture.proportional_crop
    erb :'pictures/edit'
  end

  patch '/pictures/:id' do
    picture = Picture.find(params[:id])
    if picture.user_id != current_user.id
      redirect "/pictures/#{picture.id}"
    else
    params[:ratio].all?{|x| x.to_i > 0} ? picture.update(ratio: params[:ratio].join(":")) : picture.update(ratio: params[:common])
    redirect "/pictures/#{picture.id}"
    end
  end

  delete '/pictures/:id' do
    picture = Picture.find(params[:id])
    if picture.user_id != current_user.id
      redirect "/pictures/#{picture.id}"
    else
      picture.remove
      redirect '/index'
    end
  end




end
