enable :sessions
use Rack::Flash

DataMapper.setup(:default, "appengine://auto")
#DataMapper.setup(:datastore, :adapter => :datastore, :database => 'sinatratest')

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  erb :index
end

private 
def mobile_device?
  if params[:mobile]
    session[:mobile_param] == "1"
  else
    request.user_agent =~ /Mobile|webOS/
  end
end

