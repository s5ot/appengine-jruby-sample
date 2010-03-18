class Yahoo
  def initialize(appid)
    @application_id = appid
    @cache = AppEngine::Memcache.new
  end

  def analyze(sentence)
    unless res = @cache.get(sentence.intern)
      url = "http://jlp.yahooapis.jp/MAService/V1/parse?appid=#{@application_id}&results=ma,uniq&uniq_filter=9|10&sentence=#{URI.encode(sentence)}"
      res = request(url)
      doc = REXML::Document.new(res.body).elements['ResultSet/ma_result/word_list/']
      @cache.set(sentence.intern, res)
    end

    result = []
   	doc.elements.each('word') do |item|
		word = {}
		item.elements.each do |property|
			word["#{property.name}"] = property.text
		end
		result << word
	end
	result
  end

  private

  def request(url, method = 'GET', options = {})
    options[:method]  = method
    AppEngine::URLFetch.fetch(url, options)
  end
end
