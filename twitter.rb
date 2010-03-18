class Twitter

  def initialize(username, password)
    @req = Net::HTTP::Get.new('/')
    @req.basic_auth username, password
    @cache = AppEngine::Memcache.new
  end

  def user_timeline(screen_name)
    unless timeline = @cache.get(screen_name.intern)
      url = "http://twitter.com/statuses/user_timeline/#{screen_name}.json"
      res = request(url)
      timeline = JSON.parser.new(res.body).parse
      @cache.set(screen_name.intern, timeline)
    end
   

  timeline
  end

  private

  def request(url, method = 'GET', options = {})
    options[:method]  = method
    options[:headers] = { 'Authorization' => @req['Authorization'] }
    AppEngine::URLFetch.fetch(url, options)
  end
end
