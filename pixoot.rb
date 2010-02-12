require File.dirname(__FILE__) + '/vendor/gems/environment'
Bundler.require_env

set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'

get '/' do
  @initial_color = "FFFFFF"
  @initial_transparency = "20"
  
  erb :index
end

get %r{/pixel/([0-9A-F]{6})_([0-9]{1,3}).png} do |color, transparency|
  
  # set caching policies
  response['Cache-Control'] = 'max-age=315360000, public'
  response['Expires'] = (Time.now + 315360000).httpdate
  
  # validate tranparency
  transparency = transparency.to_i
  tranparency = 100 if transparency > 100
  tranparency = 0 if transparency < 0
  
  rgb = color.scan(/../).map { |channel| channel.to_i(16) }  # get array of RGB channel values from hex color
  alpha = (255 * ((100 - transparency) / 100.0)).to_i
  png = ChunkyPNG::Image.new(1, 1, ChunkyPNG::Color.rgba(rgb[0], rgb[1], rgb[2], alpha))
  
  content_type 'image/png'
  return png.to_s
end
