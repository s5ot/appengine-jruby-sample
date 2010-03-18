
get '/list_images' do
  @images = Image.all(:order =>[:updated_at.desc])
  erb :list_images
end

get '/show_image/:id' do
  @image = Image.get(params[:id])
  erb :show_image
end

get '/new_image' do
  @image = Image.new
  erb :new_image
end

post '/create_image' do
  @image = Image.new(params[:image])
  if @image.save
    flash[:notice] = "Successfully created image."
    redirect "show_image/#{@image.id}"
  else
    erb :new_image
  end
end

get '/edit_image/:id' do
  @image = Image.get(params[:id])
  erb :edit_image
end

post '/update_image/:id' do
  @image = Image.get(params[:id])
  @image.title = params[:image][:title]
  @image.attachment = params[:image][:attachment]
  if @image.save
    flash[:notice] = "Successfully updated image."
    redirect '/list_images'
  else
    erb :edit_image
  end
end

get '/destroy_image/:id' do
  @image = Image.get(params[:id])
  @image.destroy
  flash[:notice] = "Successfully destroyed image."
  redirect '/list_images'
end

get '/puts_image/:id' do
  @image = Image.get(params[:id].to_i)
  send_data(@image.data, :disposition => 'inline', :type => @image.type)
end

get '/puts_crop_image_mini/:id' do
  height = 48.0
  width = 48.0
  crop_image(height, width)
end

get '/puts_crop_image/:id' do
  height = 160.0
  width = 160.0
  crop_image(height, width)
end

get '/puts_resize_image/:id' do
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  image = image.resize(150, 150)
  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

get '/puts_rotate_image/:id' do
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  image = image.rotate(90)
  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

get '/puts_flip_image/:id' do
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  image = image.flip(:horizontal)
  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

get '/puts_scale_image/:id' do
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  image = image.scale(2)
  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

get '/puts_clip_image/:id' do
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  image = image.clip(0.1)
  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

get '/puts_i_feel_lucky_image/:id' do
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  image = image.i_feel_lucky
  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

private
def crop_image(height, width)
  @image = Image.get(params[:id].to_i)
  image = AppEngine::Images.load(@image.data)
  org_width = image.width
  org_height = image.height

  scale_w = height / org_width
  scale_h = height / org_height
  scale =  (scale_w < scale_h)? scale_h : scale_w

  thumbnail_width = (org_width * scale).to_i
  thumbnail_height = (org_height * scale).to_i
  image = image.resize(thumbnail_width, thumbnail_height)

  x  = (thumbnail_width - width) / 2.0
  y  = (thumbnail_height - height) / 2.0
  image = image.crop(x/thumbnail_width, y/thumbnail_height, 1.0-(x/thumbnail_width), 1.0-(y/thumbnail_height))

  send_data(image.data, :disposition => 'inline', :type => @image.type)
end

def send_data(data, option)
  content_type "'#{option[:type]}'"
  response['Content-Disposition'] = "#{option[:disposition]};"
  data
end
