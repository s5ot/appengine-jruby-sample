enable :sessions
use Rack::Flash

DataMapper.setup(:default, "appengine://auto")
#DataMapper.setup(:datastore, :adapter => :datastore, :database => 'sinatratest')

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

